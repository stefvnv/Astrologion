import UIKit

class TransitChartViewModel: NatalChartViewModel {
    var currentTransits: [Transit] = []
    var transitingPlanetPositions: [CGPoint] = []

    func calculateTransitingPlanetPositions(in rect: CGRect) {
        guard let chart = chart, let ascendantString = chart.houseCusps["House 1"], let ascendant = LongitudeParser.parseLongitude(from: ascendantString) else { return }
        
        transitingPlanetPositions.removeAll()
        
        let natalChartRadius = min(rect.width, rect.height) / 2
        let transitingPlanetOffset: CGFloat = 20
        let transitingPlanetRadius = natalChartRadius + transitingPlanetOffset
        
        for transit in currentTransits {
            let position = AstrologicalCalculations.calculatePositionForPlanet(transit.planet, at: transit.longitude, usingAscendant: ascendant, in: rect)
            transitingPlanetPositions.append(position)
        }
    }
}
