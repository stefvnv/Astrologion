import Foundation

class TransitChartViewModel {
    var transits: [Transit]
    var ascendant: Double?
    var natalChart: Chart?
    var houseCusps: [Double]?

    init(transits: [Transit], natalChart: Chart?, ascendant: Double?, houseCusps: [Double]?) {
        self.transits = transits
        self.natalChart = natalChart
        self.ascendant = ascendant
        self.houseCusps = houseCusps
    }

    func updateTransits(newTransits: [Transit]) {
        self.transits = newTransits
    }

    func calculateTransitAspectPositions(in rect: CGRect) -> [TransitPosition] {
        guard let ascendant = ascendant, let natalChart = self.natalChart else { return [] }
        
        return transits.compactMap { transit in
            let transitingPosition = AstrologicalCalculations.calculatePositionForPlanet(
                transit.planet,
                at: transit.longitude,
                usingAscendant: ascendant,
                in: rect
            )
            
            // Retrieve the longitude for the natal planet.
            guard let natalLongitude = natalChart.planetaryPositions[transit.natalPlanet.rawValue].flatMap(LongitudeParser.parseLongitude) else {
                return nil
            }
            
            let natalPosition = AstrologicalCalculations.calculatePositionForPlanet(
                transit.natalPlanet,
                at: natalLongitude,
                usingAscendant: ascendant,
                in: rect
            )
            
            return TransitPosition(transit: transit, position: transitingPosition, natalPosition: natalPosition)
        }
    }
}

struct TransitPosition {
    let transit: Transit
    let position: CGPoint
    let natalPosition: CGPoint 
}
