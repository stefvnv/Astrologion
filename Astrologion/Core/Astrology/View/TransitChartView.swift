import UIKit

class TransitChartView: UIView {
    private var natalChartView: NatalChartView?
    private var viewModel: TransitChartViewModel?

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

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext(),
              let viewModel = viewModel,
              let natalChartView = natalChartView else { return }

        natalChartView.viewModel = NatalChartViewModel(chart: viewModel.natalChart)
        natalChartView.shouldDrawAspects = false
        natalChartView.setNeedsDisplay()

        drawTransitingPlanets(context: context, rect: rect, transits: viewModel.transits, ascendant: viewModel.ascendant ?? 0.0)

        // draw transit lines
        let transitAspectPositions = viewModel.calculateTransitAspectPositions(in: rect)
        for transitAspectPosition in transitAspectPositions {
            drawTransitAspect(context: context, position: transitAspectPosition.position, natalPosition: transitAspectPosition.natalPosition, houseInnerRadius: natalChartView.houseInnerRadius, aspect: transitAspectPosition.aspect)
        }
        
        // draw conjunction circles
        drawConjunctionCircles(context: context, viewModel: viewModel, rect: rect)

        context.restoreGState()
    }

    private func drawTransitingPlanets(context: CGContext, rect: CGRect, transits: [Transit], ascendant: Double) {
        let natalChartRadius = natalChartView?.bounds.width ?? rect.width / 2
        let transitingPlanetOffset: CGFloat = 60
        let transitingPlanetRadius = natalChartRadius + transitingPlanetOffset
        let fontSize = transitingPlanetRadius / 12
        
        for transit in transits {
            let position = AstrologicalCalculations.calculatePositionForPlanet(transit.planet, at: transit.longitude, usingAscendant: ascendant, in: rect)
            let planetColor = transit.planet.color
            let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: fontSize), .foregroundColor: planetColor]
            
            if let symbol = transit.planet.symbol {
                let planetSymbol = NSAttributedString(string: symbol, attributes: attributes)
                let textSize = planetSymbol.size()
                let adjustedPosition = CGPoint(x: position.x - textSize.width / 2, y: position.y - textSize.height / 2)
                planetSymbol.draw(at: adjustedPosition)
            }
        }
    }
    
    private func drawTransitAspect(context: CGContext, position: CGPoint, natalPosition: CGPoint, houseInnerRadius: CGFloat, aspect: Aspect) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
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
    
    
    private func drawConjunctionCircles(context: CGContext, viewModel: TransitChartViewModel, rect: CGRect) {
        let conjunctions = viewModel.transits.filter { transit in
            transit.aspects.contains { $0 == .conjunction }
        }
        let radius = natalChartView?.houseInnerRadius ?? 0
        let center = CGPoint(x: rect.midX, y: rect.midY)
        
        let adjustedRadius = radius * 0.74
        
        context.setStrokeColor(Aspect.conjunction.uiColor.cgColor)
        context.setLineWidth(1)
        
        for conjunction in conjunctions {
            let planetPosition = AstrologicalCalculations.calculatePositionForPlanet(conjunction.planet, at: conjunction.longitude, usingAscendant: viewModel.ascendant ?? 0.0, in: rect)
            let intersectionPoint = intersectionPointOnCircle(circleCenter: center, circleRadius: adjustedRadius, externalPoint: planetPosition)
            
            context.addArc(center: intersectionPoint, radius: 8, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            
            context.strokePath()
        }
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
