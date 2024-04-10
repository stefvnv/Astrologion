import UIKit

class TransitChartView: UIView {
    private var natalChartView: NatalChartView?
    private var viewModel: TransitChartViewModel?
    
    var selectedPlanet: Planet?
    
    var transitsViewModel: TransitsViewModel? {
        didSet {
            updateViewModel()
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeView()
    }
    
    private func initializeView() {
        backgroundColor = .clear
        natalChartView = NatalChartView()
        if let natalChartView = natalChartView {
            addSubview(natalChartView)
        }
    }
    
    private func updateViewModel() {
        guard let transitsViewModel = transitsViewModel,
              let userChart = transitsViewModel.userChart,
              let ascendant = userChart.houseCusps["House 1"].flatMap(LongitudeParser.parseLongitude) else {
            viewModel = nil
            return
        }
        
        viewModel = TransitChartViewModel(transits: transitsViewModel.currentTransits, natalChart: userChart, ascendant: ascendant, houseCusps: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        natalChartView?.frame = bounds
    }
    
    
    func ascendantPosition(in rect: CGRect) -> CGPoint {
        guard let viewModel = viewModel else { return .zero }
        let ascendantLongitude = viewModel.ascendant()
        return AstrologicalCalculations.calculatePositionForPoint(at: ascendantLongitude, usingAscendant: ascendantLongitude, in: rect)
    }
    
    func midheavenPosition(in rect: CGRect) -> CGPoint {
        guard let viewModel = viewModel else { return .zero }
        let midheavenLongitude = viewModel.midheaven()
        let ascendantLongitude = viewModel.ascendant() // Assuming the Ascendant is used as the reference for drawing
        return AstrologicalCalculations.calculatePositionForPoint(at: midheavenLongitude, usingAscendant: ascendantLongitude, in: rect)
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext(),
              let viewModel = viewModel,
              let natalChartView = natalChartView else { return }
        
        context.saveGState()
        defer { context.restoreGState() }
        
        natalChartView.viewModel = NatalChartViewModel(chart: viewModel.natalChart)
        natalChartView.shouldDrawAspects = false
        natalChartView.setNeedsDisplay()
        
        let transitAspectPositions = viewModel.calculateAllTransitAspectPositions(in: rect)
        for transitAspectPosition in transitAspectPositions {
            if selectedPlanet == nil || transitAspectPosition.transitingPlanet == selectedPlanet {
                drawTransitAspect(context: context, position: transitAspectPosition.position, natalPosition: transitAspectPosition.natalPosition, houseInnerRadius: natalChartView.houseInnerRadius, aspect: transitAspectPosition.aspect, natalPlanet: transitAspectPosition.natalPlanet, rect: rect)
            }
        }
        
        for transit in viewModel.transits {
            if selectedPlanet == nil || transit.planet == selectedPlanet {
                drawTransitPlanet(context: context, transit: transit, rect: rect, ascendant: viewModel.ascendantDegree ?? 0.0)
            }
        }
        
        if selectedPlanet == nil {
            drawConjunctionCircles(context: context, conjunctions: viewModel.transits.filter { $0.aspects.contains(.conjunction) }, rect: rect)
        } else {
            drawConjunctionCirclesForSelectedPlanet(context: context, viewModel: viewModel, rect: rect, selectedPlanet: selectedPlanet)
        }
        
        context.restoreGState()
    }
    
    
    private func drawTransitPlanet(context: CGContext, transit: Transit, rect: CGRect, ascendant: Double) {
        let baseRadius = natalChartView?.houseInnerRadius ?? (min(bounds.size.width, bounds.size.height) / 2 * 0.8 * 0.7)
        let transitingPlanetOffset: CGFloat = baseRadius + 70
        let fontSize: CGFloat = 20
        
        var position = AstrologicalCalculations.calculatePositionForPlanet(transit.planet, at: transit.longitude, usingAscendant: ascendant, in: rect)
        
        let angle = atan2(position.y - rect.midY, position.x - rect.midX)
        position.x = rect.midX + (transitingPlanetOffset * cos(angle))
        position.y = rect.midY + (transitingPlanetOffset * sin(angle))
        
        let planetColor = transit.planet.color
        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: fontSize), .foregroundColor: planetColor]
        
        if let symbol = transit.planet.symbol {
            let planetSymbol = NSAttributedString(string: symbol, attributes: attributes)
            let textSize = planetSymbol.size()
            let adjustedPosition = CGPoint(x: position.x - textSize.width / 2, y: position.y - textSize.height / 2)
            planetSymbol.draw(at: adjustedPosition)
        } else {
            print("No symbol found for \(transit.planet.rawValue)")
        }
    }
    
    
    private func drawTransitAspect(context: CGContext, position: CGPoint, natalPosition: CGPoint, houseInnerRadius: CGFloat, aspect: Aspect, natalPlanet: Planet, rect: CGRect) {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let transitingIntersection = intersectionPointOnCircle(circleCenter: center, circleRadius: houseInnerRadius, externalPoint: position)
        let natalIntersection = intersectionPointOnCircle(circleCenter: center, circleRadius: houseInnerRadius, externalPoint: natalPosition)
        
        let scaledTransitingIntersection = scalePoint(point: transitingIntersection, center: center, scale: 0.8)
        let scaledNatalIntersection = scalePoint(point: natalIntersection, center: center, scale: 0.8)
        
        context.setStrokeColor(aspect.uiColor.cgColor)
        context.setLineWidth(2)
        context.beginPath()
        context.move(to: scaledTransitingIntersection)
        context.addLine(to: scaledNatalIntersection)
        context.strokePath()
    }
    
    
    private func calculateAscendantOrMidheavenPosition(for planet: Planet, in rect: CGRect) -> CGPoint {
        guard let viewModel = viewModel else { return .zero }
        let ascendantLongitude = viewModel.ascendant()
        let midheavenLongitude = viewModel.midheaven()
        
        switch planet {
        case .Ascendant:
            return AstrologicalCalculations.calculatePositionForPoint(at: ascendantLongitude, usingAscendant: ascendantLongitude, in: rect)
        case .Midheaven:
            return AstrologicalCalculations.calculatePositionForPoint(at: midheavenLongitude, usingAscendant: ascendantLongitude, in: rect)
        default:
            return .zero
        }
    }
    
    private func drawConjunctionCircles(context: CGContext, conjunctions: [Transit], rect: CGRect) {
        let radius = natalChartView?.houseInnerRadius ?? 0
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let adjustedRadius = radius * 0.74
        
        context.setStrokeColor(Aspect.conjunction.uiColor.cgColor)
        context.setLineWidth(1)
        
        for conjunction in conjunctions {
            let planetPosition = AstrologicalCalculations.calculatePositionForPlanet(conjunction.planet, at: conjunction.longitude, usingAscendant: viewModel?.ascendantDegree ?? 0.0, in: rect)
            let intersectionPoint = intersectionPointOnCircle(circleCenter: center, circleRadius: adjustedRadius, externalPoint: planetPosition)
            
            context.addArc(center: intersectionPoint, radius: 8, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            context.strokePath()
        }
    }
    
    private func drawConjunctionCirclesForSelectedPlanet(context: CGContext, viewModel: TransitChartViewModel, rect: CGRect, selectedPlanet: Planet?) {
        guard let selectedPlanet = selectedPlanet else { return }
        
        let conjunctions = viewModel.transits.filter { transit in
            transit.planet == selectedPlanet && transit.aspects.contains(.conjunction)
        }
        
        drawConjunctionCircles(context: context, conjunctions: conjunctions, rect: rect)
    }
    
    private func intersectionPointOnCircle(circleCenter: CGPoint, circleRadius: CGFloat, externalPoint: CGPoint) -> CGPoint {
        let dx = externalPoint.x - circleCenter.x
        let dy = externalPoint.y - circleCenter.y
        let distance = sqrt(dx * dx + dy * dy)
        let scale = circleRadius / distance
        return CGPoint(x: circleCenter.x + scale * dx, y: circleCenter.y + scale * dy)
    }
    
    private func scalePoint(point: CGPoint, center: CGPoint, scale: CGFloat) -> CGPoint {
        let dx = point.x - center.x
        let dy = point.y - center.y
        return CGPoint(x: center.x + scale * dx, y: center.y + scale * dy)
    }
    
    
} // end
