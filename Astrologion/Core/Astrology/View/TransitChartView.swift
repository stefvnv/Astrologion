import UIKit

class TransitChartView: UIView {
    private var natalChartView: NatalChartView?
    private var viewModel: TransitChartViewModel?  // Use TransitChartViewModel here

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
        if natalChartView == nil {
            let natalChart = NatalChartView()
            natalChartView = natalChart
            addSubview(natalChart)
        }
    }

    private func updateViewModel() {
        guard let transitsViewModel = transitsViewModel,
              let userChart = transitsViewModel.userChart,
              let ascendantString = userChart.houseCusps["House 1"],
              let ascendant = LongitudeParser.parseLongitude(from: ascendantString) else {
            viewModel = nil
            return
        }

        let transits = transitsViewModel.currentTransits
        viewModel = TransitChartViewModel(transits: transits, natalChart: userChart, ascendant: ascendant, houseCusps: nil)
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
        
        // Disable natal aspects drawing
        natalChartView.shouldDrawAspects = false
        natalChartView.setNeedsDisplay()

        // Draw transiting planets
        drawTransitingPlanets(context: context, rect: rect, transits: viewModel.transits, ascendant: viewModel.ascendant ?? 0.0)

        // Get the positions where transits intersect with the house inner circle
        let transitAspectPositions = viewModel.calculateTransitAspectPositions(in: rect)

        // Draw the lines for each transit aspect within the bounds of the inner circle
        transitAspectPositions.forEach { transitPosition in
            drawTransitAspect(context: context, position: transitPosition, houseInnerRadius: natalChartView.houseInnerRadius)
        }
        
        context.restoreGState() // Restore graphics state at the end
    }



    
    private func drawTransitingPlanets(context: CGContext, rect: CGRect, transits: [Transit], ascendant: Double) {
        guard let natalChartView = natalChartView else { return }
        
        let natalChartRadius = natalChartView.bounds.width / 2
        let transitingPlanetOffset: CGFloat = 60 // distance from zodiac outer circle size
        let transitingPlanetRadius = natalChartRadius + transitingPlanetOffset
        let fontSize = transitingPlanetRadius / 12 // font size
        
        for transit in transits {
            let position = AstrologicalCalculations.calculatePositionForPlanet(
                transit.planet,
                at: transit.longitude,
                usingAscendant: ascendant,
                in: CGRect(x: rect.midX - transitingPlanetRadius, y: rect.midY - transitingPlanetRadius, width: transitingPlanetRadius * 2, height: transitingPlanetRadius * 2)
            )
            
            // draw planets
            let planetColor = transit.planet.color
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: fontSize),
                .foregroundColor: planetColor
            ]
            
            if let symbol = transit.planet.symbol {
                let planetSymbol = NSAttributedString(string: symbol, attributes: attributes)
                let textSize = planetSymbol.size()
                let adjustedPosition = CGPoint(
                    x: position.x - textSize.width / 2,
                    y: position.y - textSize.height / 2
                )
                planetSymbol.draw(at: adjustedPosition)
            }
        }
    }
    
    private func drawTransitAspect(context: CGContext, position: TransitPosition, houseInnerRadius: CGFloat) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)

        // Calculate intersection points on the house inner circle for both the transiting and natal planet positions
        let transitingIntersection = intersectionPointOnCircle(circleCenter: center, circleRadius: houseInnerRadius, externalPoint: position.position)
        let natalIntersection = intersectionPointOnCircle(circleCenter: center, circleRadius: houseInnerRadius, externalPoint: position.natalPosition)

        // Scale the intersection points if they're too far from the center
        let scaledTransitingIntersection = scalePoint(point: transitingIntersection, center: center, scale: 0.8)
        let scaledNatalIntersection = scalePoint(point: natalIntersection, center: center, scale: 0.8)

        // Draw the line for the transit aspect within the house inner circle
        context.setStrokeColor(position.transit.aspect.uiColor.cgColor)
        context.setLineWidth(2) // Adjust line width as needed
        context.beginPath()
        context.move(to: scaledTransitingIntersection)
        context.addLine(to: scaledNatalIntersection)
        context.strokePath()
    }

    private func scalePoint(point: CGPoint, center: CGPoint, scale: CGFloat) -> CGPoint {
        let dx = point.x - center.x
        let dy = point.y - center.y
        return CGPoint(x: center.x + scale * dx, y: center.y + scale * dy)
    }



    private func intersectionPointOnCircle(circleCenter: CGPoint, circleRadius: CGFloat, externalPoint: CGPoint) -> CGPoint {
        let dx = externalPoint.x - circleCenter.x
        let dy = externalPoint.y - circleCenter.y
        let scale = circleRadius / sqrt(dx * dx + dy * dy)
        return CGPoint(x: circleCenter.x + scale * dx, y: circleCenter.y + scale * dy)
    }
    
    private func drawPlanetSymbol(planet: Planet, at position: CGPoint, context: CGContext) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .foregroundColor: UIColor.blue
        ]
        
        if let symbol = planet.symbol {
            let planetSymbol = NSAttributedString(string: symbol, attributes: attributes)
            let textSize = planetSymbol.size()
            planetSymbol.draw(at: CGPoint(x: position.x - textSize.width / 2, y: position.y - textSize.height / 2))
        }
    }
}
