import Foundation

class NatalChartViewModel {
    @Published var chart: Chart?
    @Published var aspects: [AstrologicalAspectData] = []

    
    ///
    init(chart: Chart?) {
        self.chart = chart
        self.aspects = parseAspects(from: chart)
        
        
        // TO BE DELETED
        if let chart = chart {
            print("Chart data received: \(chart)")
        }
    }
    
    
    ///
    private func parseAspects(from chart: Chart?) -> [AstrologicalAspectData] {
        guard let chart = chart else { return [] }

        let aspectPattern = "([A-Za-z]+) ([A-Za-z]+) ([A-Za-z]+) at (\\d+\\.\\d+)° with orb of (\\d+\\.\\d+)°"
        let regex = try? NSRegularExpression(pattern: aspectPattern, options: [])

        return chart.aspects.compactMap { aspectDescription in
            guard let match = regex?.firstMatch(in: aspectDescription, options: [], range: NSRange(aspectDescription.startIndex..., in: aspectDescription)) else {
                return nil
            }
            
            func capture(_ index: Int) -> String {
                let range = Range(match.range(at: index), in: aspectDescription)!
                return String(aspectDescription[range])
            }
            
            guard let planet1 = Planet(rawValue: capture(1)),
                  let aspectType = Aspect.allCases.first(where: { $0.description.lowercased() == capture(2).lowercased() }),
                  let planet2 = Planet(rawValue: capture(3)),
                  let exactAngle = Double(capture(4)),
                  let orb = Double(capture(5)) else {
                return nil
            }
            
            return AstrologicalAspectData(planet1: planet1, planet2: planet2, aspect: aspectType, exactAngle: exactAngle, orb: orb)
        }
    }
    
    
    ///
    func longitude(for planet: Planet) -> Double {
        guard let chart = chart, let positionString = chart.planetaryPositions[planet.rawValue] else { return 0.0 }
        return parseLongitude(from: positionString) ?? 0.0
    }
    
    
    ///
    func houseCusps() -> [Double] {
        guard let chart = chart else { return [] }
        return (1...12).compactMap { index -> Double? in
            guard let cuspString = chart.houseCusps["House \(index)"] else { return nil }
            return parseLongitude(from: cuspString)
        }
    }

    
    ///
    func ascendant() -> Double {
        guard let chart = chart, let ascendantString = chart.houseCusps["House 1"] else { return 0.0 }
        
        print("Ascendant Longitude: \(parseLongitude(from: ascendantString) ?? 0.0)")

        return parseLongitude(from: ascendantString) ?? 0.0
    }

    
    ///
    func midheaven() -> Double {
        guard let chart = chart, let midheavenString = chart.houseCusps["House 10"] else { return 0.0 }
        
        print("Midheaven Longitude: \(parseLongitude(from: midheavenString) ?? 0.0)")
        
        return parseLongitude(from: midheavenString) ?? 0.0
    }
    
    
    ///
    private func parseLongitude(from string: String) -> Double? {
        let components = string.components(separatedBy: " ")
        guard components.count == 2,
              let zodiacSign = Zodiac(rawValue: components[0]),
              let degreesComponent = components.last else { return nil }

        let degreesMinutes = degreesComponent.components(separatedBy: "°")
        guard degreesMinutes.count == 2,
              let degrees = Double(degreesMinutes[0]),
              let minutes = Double(degreesMinutes[1].trimmingCharacters(in: CharacterSet(charactersIn: "'"))) else { return nil }

        let result = zodiacSign.baseDegree + degrees + minutes / 60.0
        print("Parsed longitude from '\(string)' to \(result) degrees")
        return result
    }

    
    ///
    func calculatePositionForPlanet(_ planet: Planet, at longitude: Double, usingAscendant ascendant: Double, in rect: CGRect) -> CGPoint {
        let ascendantOffset = 180.0 - ascendant
        let adjustedLongitude = longitude + ascendantOffset
        let angle = (360 - (adjustedLongitude.truncatingRemainder(dividingBy: 360))).truncatingRemainder(dividingBy: 360)
        let radians = angle.degreesToRadians
        
        let outerRadius = min(rect.size.width, rect.size.height) / 2
        let planetRadius = (outerRadius + outerRadius * 0.8) / 2.5
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let x = center.x + planetRadius * cos(radians)
        let y = center.y + planetRadius * sin(radians)
        
        print("Calculating position for \(planet.rawValue): Longitude: \(longitude), Adjusted Longitude: \(adjustedLongitude), Radians: \(radians), Position: (\(x), \(y))")
        return CGPoint(x: x, y: y)
    }

    
    ///
    func getPlanetPositions(in rect: CGRect) -> [PlanetPosition] {
        guard let chart = chart else {
            print("No chart data available.")
            return []
        }

        let ascendantLongitude = self.ascendant() // Confirm this method gets the correct ascendant value from the chart.

        return Planet.allCases.compactMap { planet in
            guard let positionString = chart.planetaryPositions[planet.rawValue],
                  let planetLongitude = parseLongitude(from: positionString) else {
                print("Could not parse position for \(planet.rawValue)")
                return nil
            }

            let position = calculatePositionForPlanet(planet, at: planetLongitude, usingAscendant: ascendantLongitude, in: rect)
            print("Calculated position for \(planet.rawValue): \(position), Longitude: \(planetLongitude)")
            
            
            
            
            return PlanetPosition(planet: planet, position: position, longitude: CGFloat(planetLongitude))
        }
    }

    
    ///
    func angleForHouseCusp(houseNumber: Int) -> Double {
        guard let chart = chart else { return 0.0 }
        guard houseNumber >= 1 && houseNumber <= 12 else { return 0.0 }

        guard let cuspString = chart.houseCusps["House \(houseNumber)"],
              let cuspLongitude = parseLongitude(from: cuspString) else {
            return 0.0
        }

        guard let ascendantString = chart.houseCusps["House 1"],
              let ascendantLongitude = parseLongitude(from: ascendantString) else {
            return 0.0
        }

        let adjustedLongitude = cuspLongitude - ascendantLongitude
        let angle = (adjustedLongitude.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)

        return angle
    }


} //end
