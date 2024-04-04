import UIKit

class TransitChartView: UIView {
    private var natalChartView: NatalChartView?
    
    var transitsViewModel: TransitsViewModel? {
        didSet {
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        natalChartView?.frame = bounds
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext(),
              let viewModel = transitsViewModel,
              let userChart = viewModel.userChart,
              let ascendant = userChart.houseCusps["House 1"].flatMap(LongitudeParser.parseLongitude) else { return }
        
        natalChartView?.viewModel = NatalChartViewModel(chart: userChart)        
        natalChartView?.setNeedsDisplay()
        
        drawTransitingPlanets(context: context, rect: rect, transits: viewModel.currentTransits, ascendant: ascendant)
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
