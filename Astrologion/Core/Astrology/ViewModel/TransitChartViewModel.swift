import Foundation

class TransitChartViewModel {
    var transits: [Transit]
    var ascendantDegree: Double?
    var natalChart: Chart?
    var houseCusps: [Double]?
    var selectedPlanet: Planet?

    init(transits: [Transit], natalChart: Chart?, ascendant: Double?, houseCusps: [Double]?) {
        self.transits = transits
        self.natalChart = natalChart
        self.ascendantDegree = ascendant
        self.houseCusps = houseCusps
    }
    
    
    func ascendant() -> Double {
        guard let ascendantString = natalChart?.houseCusps["House 1"] else { return 0.0 }
        return LongitudeParser.parseLongitude(from: ascendantString) ?? 0.0
    }

    func midheaven() -> Double {
        guard let midheavenString = natalChart?.houseCusps["House 10"] else { return 0.0 }
        return LongitudeParser.parseLongitude(from: midheavenString) ?? 0.0
    }

    
    func calculateAllTransitAspectPositions(in rect: CGRect) -> [(position: CGPoint, natalPosition: CGPoint, aspect: Aspect, transitingPlanet: Planet, natalPlanet: Planet)] {
        guard let ascendant = ascendantDegree, let natalChart = natalChart else { return [] }
        
        var transitAspectPositions: [(position: CGPoint, natalPosition: CGPoint, aspect: Aspect, transitingPlanet: Planet, natalPlanet: Planet)] = []

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

            for aspect in transit.aspects {
                let natalPosition: CGPoint
                if let natalPlanet = transit.natalPlanet {
                    if natalPlanet == .Ascendant {
                        let ascendantLongitude = self.ascendant()
                        natalPosition = AstrologicalCalculations.calculatePositionForPoint(at: ascendantLongitude, usingAscendant: ascendant, in: rect)
                    } else if natalPlanet == .Midheaven {
                        let midheavenLongitude = self.midheaven()
                        natalPosition = AstrologicalCalculations.calculatePositionForPoint(at: midheavenLongitude, usingAscendant: ascendant, in: rect)
                    } else if let natalLongitudeString = natalChart.planetaryPositions[natalPlanet.rawValue],
                              let natalLongitude = LongitudeParser.parseLongitude(from: natalLongitudeString) {
                        natalPosition = AstrologicalCalculations.calculatePositionForPlanet(
                            natalPlanet,
                            at: natalLongitude,
                            usingAscendant: ascendant,
                            in: rect
                        )
                    } else {
                        continue
                    }
                    
                    transitAspectPositions.append((position: transitingPosition, natalPosition: natalPosition, aspect: aspect, transitingPlanet: transit.planet, natalPlanet: natalPlanet))
                }
            }
        }

        return transitAspectPositions
    }

    
} // end
