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

    func calculateTransitAspectPositions(in rect: CGRect) -> [(position: CGPoint, natalPosition: CGPoint, aspect: Aspect)] {
        guard let ascendant = ascendant, let natalChart = self.natalChart else { return [] }
        
        var transitAspectPositions: [(position: CGPoint, natalPosition: CGPoint, aspect: Aspect)] = []

        for transit in transits {
            let transitingPosition = AstrologicalCalculations.calculatePositionForPlanet(
                transit.planet,
                at: transit.longitude,
                usingAscendant: ascendant,
                in: rect
            )
            
            guard let natalLongitude = natalChart.planetaryPositions[transit.natalPlanet.rawValue].flatMap(LongitudeParser.parseLongitude) else {
                continue
            }
            
            let natalPosition = AstrologicalCalculations.calculatePositionForPlanet(
                transit.natalPlanet,
                at: natalLongitude,
                usingAscendant: ascendant,
                in: rect
            )

            for aspect in transit.aspects {
                transitAspectPositions.append((position: transitingPosition, natalPosition: natalPosition, aspect: aspect))
            }
        }
        return transitAspectPositions
    }

    
} // end

struct TransitPosition {
    let transit: Transit
    let position: CGPoint
    let natalPosition: CGPoint 
}
