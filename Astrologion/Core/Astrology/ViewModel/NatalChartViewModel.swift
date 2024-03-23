import Foundation

class NatalChartViewModel {
    @Published var astrologicalService: AstrologyModel?
    
    
    ///
    init(service: AstrologyModel?) {
        self.astrologicalService = service
    }
    
    // NOT WORKING
    ///
    func handleTap(location: CGPoint, inViewBounds bounds: CGRect) {
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let deltaX = location.x - center.x
        let deltaY = location.y - center.y
        var angle = atan2(deltaY, deltaX) * 180 / .pi
        angle = (angle < 0) ? (360 + angle) : angle
        angle = 360 - angle
        print("Tapped at angle: \(angle)°")

        let houseInnerRadius = min(bounds.size.width, bounds.size.height) / 2 * 0.8 * 0.7
        let distanceFromCenter = sqrt(pow(deltaX, 2) + pow(deltaY, 2))
        let maxRadiusForHouses = min(bounds.size.width, bounds.size.height) / 2

        if distanceFromCenter >= houseInnerRadius && distanceFromCenter <= maxRadiusForHouses {
            let planetPositions = getPlanetPositions(in: bounds)
            for planetPosition in planetPositions {
                if isTapNearPlanet(tapLocation: location, planetPosition: planetPosition.position) {
                    print("Tapped on \(planetPosition.planet)")
                    return
                }
            }

            if let tappedHouse = houseTapped(angle: angle) {
                print("Tapped in house \(tappedHouse)")
            } else {
                // New functionality to check for taps near transits
                let tapAngle = calculateAngle(from: center, to: location)
                if let transitTapped = isTapNearTransit(tapAngle: tapAngle, center: center, tapLocation: location) {
                    print("Tapped on transit between \(transitTapped.planet1) and \(transitTapped.planet2) with aspect \(transitTapped.aspect)")
                } else {
                    print("Tapped in the house area but not on a specific house or transit")
                }
            }
        } else {
            print("Tapped outside of the house area")
        }
    }



    // TRANSITS
    func calculateAngle(from center: CGPoint, to location: CGPoint) -> Double {
        let deltaX = location.x - center.x
        let deltaY = location.y - center.y
        var angle = atan2(deltaY, deltaX) * 180 / .pi
        angle = (angle < 0) ? (360 + angle) : angle
        return angle
    }
    
    func isTapNearTransit(tapAngle: Double, center: CGPoint, tapLocation: CGPoint) -> AstrologicalAspectData? {
        let aspects = calculateAspects()
        let threshold = 5.0
        
        for aspectData in aspects {
            let planet1Position = calculatePositionForPlanet(aspectData.planet1, at: aspectData.planet1.longitude(using: astrologicalService!), usingAscendant: ascendant(), in: CGRect(x: 0, y: 0, width: center.x * 2, height: center.y * 2))
            let planet2Position = calculatePositionForPlanet(aspectData.planet2, at: aspectData.planet2.longitude(using: astrologicalService!), usingAscendant: ascendant(), in: CGRect(x: 0, y: 0, width: center.x * 2, height: center.y * 2))
            
            let aspectAngle = calculateAngle(from: planet1Position, to: planet2Position)
            
            if abs(tapAngle - aspectAngle) <= threshold || abs((tapAngle - 360) - aspectAngle) <= threshold || abs(tapAngle - (aspectAngle - 360)) <= threshold {
                return aspectData
            }
        }
        
        return nil
    }
    ///



    // PLANET
    func isTapNearPlanet(tapLocation: CGPoint, planetPosition: CGPoint, threshold: CGFloat = 20.0) -> Bool {
        let dx = tapLocation.x - planetPosition.x
        let dy = tapLocation.y - planetPosition.y
        let distance = sqrt(dx * dx + dy * dy)
        return distance <= threshold
    }

    
    // HOUSE
    // HOUSE (working)
    func houseTapped(angle: Double) -> Int? {
        let houseCusps = self.houseCusps()
        guard houseCusps.count == 12 else { return nil }

        let tapAngle = ((angle + 180) + 360).truncatingRemainder(dividingBy: 360)

        let ascendant = self.ascendant()
        let normalizedCusps = houseCusps.map { (($0 - ascendant + 180) + 360).truncatingRemainder(dividingBy: 360) }.sorted()

        for (index, cusp) in normalizedCusps.enumerated() {
            let nextCuspIndex = (index + 1) % normalizedCusps.count
            let nextCusp = normalizedCusps[nextCuspIndex]

            if cusp <= nextCusp {
                if tapAngle >= cusp && tapAngle < nextCusp {
                    return (index + 1)
                }
            } else {
                if tapAngle >= cusp || tapAngle < nextCusp {
                    return (index + 1)
                }
            }
        }
        return nil
    }




    ///
    
    ///
    func longitude(for planet: Point) -> Double {
        guard let service = astrologicalService else { return 0.0 }
        return planet.longitude(using: service)
    }
    
    
    ///
    func houseCusps() -> [Double] {
        return astrologicalService?.houseCusps ?? []
    }
    
    
    ///
    func ascendant() -> Double {
        return astrologicalService?.ascendant ?? 0
    }
    

    ///
    func midheaven() -> Double {
        return astrologicalService?.midheavenLongitude ?? 0
    }

    
    ///
    func calculatePositionForPlanet(_ planet: Point, at longitude: Double, usingAscendant ascendant: Double, in rect: CGRect) -> CGPoint {
        let ascendantOffset = 180.0 - ascendant
        let adjustedLongitude = longitude + ascendantOffset
        let angle = (360 - (adjustedLongitude.truncatingRemainder(dividingBy: 360))).truncatingRemainder(dividingBy: 360)
        let radians = angle.degreesToRadians
        
        let outerRadius = min(rect.size.width, rect.size.height) / 2
        let planetRadius = (outerRadius + outerRadius * 0.8) / 2.5
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let x = center.x + planetRadius * cos(radians)
        let y = center.y + planetRadius * sin(radians)
        
        return CGPoint(x: x, y: y)
    }

    
    ///
    func getPlanetPositions(in rect: CGRect) -> [PlanetPosition] {
        guard let service = astrologicalService else { return [] }
        let ascendant = service.ascendant
        return Point.allCases.map { planet in
            let longitude = planet.longitude(using: service)
            let position = calculatePositionForPlanet(planet, at: longitude, usingAscendant: ascendant, in: rect)
            return PlanetPosition(planet: planet, position: position, longitude: longitude)
        }
    }
    
    
    ///
    func calculateAspects() -> [AstrologicalAspectData] {
        guard let planets = astrologicalService?.astrologicalPointPositions else { return [] }
        var aspects: [AstrologicalAspectData] = []
        
        for i in 0..<planets.count {
            for j in (i+1)..<planets.count {
                let (planet1, longitude1) = planets[i]
                let (planet2, longitude2) = planets[j]
                let angleDifference = abs(longitude1 - longitude2)
                let normalizedAngle = min(angleDifference, 360 - angleDifference)
                
                for aspect in Aspect.allCases {
                    if normalizedAngle >= aspect.angle - aspect.orb && normalizedAngle <= aspect.angle + aspect.orb {
                        let aspectData = AstrologicalAspectData(planet1: planet1, planet2: planet2, aspect: aspect)
                        aspects.append(aspectData)
                        
                        // TO BE DELETED
                        let aspectOrb = abs(normalizedAngle - aspect.angle) // Calculates the difference from the exact aspect angle
                        print("Aspect: \(aspect) between \(planet1) and \(planet2), Angle Difference: \(normalizedAngle), Orb: \(aspectOrb)")
                    }
                }
            }
        }
        return aspects
    }
    
    
    func angleForHouseCusp(houseNumber: Int) -> Double {
        guard let cusps = astrologicalService?.houseCusps, cusps.count >= 12 else {
            return 0.0
        }
        let cuspLongitude = houseNumber >= 1 && houseNumber <= 12 ? cusps[houseNumber - 1] : 0.0
        let ascendantLongitude = astrologicalService?.ascendant ?? 0.0
        let adjustedLongitude = cuspLongitude - ascendantLongitude
        let angle = (adjustedLongitude.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
        
        return angle
    }
}


struct AstrologicalAspectData {
    let planet1: Point
    let planet2: Point
    let aspect: Aspect
}


struct PlanetPosition {
    var planet: Point
    var position: CGPoint
    var longitude: CGFloat
}

