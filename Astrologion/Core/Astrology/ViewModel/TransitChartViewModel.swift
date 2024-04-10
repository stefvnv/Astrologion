import Foundation

class TransitChartViewModel {
    var transits: [Transit]
    var ascendant: Double?
    var natalChart: Chart?
    var houseCusps: [Double]?
    var selectedPlanet: Planet?

    init(transits: [Transit], natalChart: Chart?, ascendant: Double?, houseCusps: [Double]?) {
        self.transits = transits
        self.natalChart = natalChart
        self.ascendant = ascendant
        self.houseCusps = houseCusps
    }

    func calculateAllTransitAspectPositions(in rect: CGRect) -> [(position: CGPoint, natalPosition: CGPoint, aspect: Aspect)] {
        guard let ascendant = ascendant, let natalChart = natalChart else { return [] }
        
        var transitAspectPositions: [(position: CGPoint, natalPosition: CGPoint, aspect: Aspect)] = []

        for transit in transits {
            if let selectedPlanet = selectedPlanet, transit.planet != selectedPlanet {
                continue
            }

            let transitingPosition = AstrologicalCalculations.calculatePositionForPlanet(
                transit.planet,
                at: transit.longitude,
                usingAscendant: ascendant,
                in: rect
            )

            for natalAspect in transit.aspects {
                guard let natalPlanet = transit.natalPlanet,
                      let natalLongitudeString = natalChart.planetaryPositions[natalPlanet.rawValue],
                      let natalLongitude = LongitudeParser.parseLongitude(from: natalLongitudeString) else {
                    continue
                }
                
                let natalPosition = AstrologicalCalculations.calculatePositionForPlanet(
                    natalPlanet,
                    at: natalLongitude,
                    usingAscendant: ascendant,
                    in: rect
                )
                
                transitAspectPositions.append((position: transitingPosition, natalPosition: natalPosition, aspect: natalAspect))
            }
        }
        return transitAspectPositions
    }

    
} // end
