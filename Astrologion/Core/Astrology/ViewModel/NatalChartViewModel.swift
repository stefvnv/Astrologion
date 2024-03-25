import Foundation
import Combine

class NatalChartViewModel: ObservableObject {
    @Published var astrologyModel: AstrologyModel
    
    @Published var planetPositions: [PlanetPosition] = []
    @Published var aspects: [AstrologicalAspectData] = []
    
    @Published var needsRedraw: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    
    ///
    init() {
        self.astrologyModel = AstrologyModel() // Initialize with a default AstrologyModel
        setupBindings()
    }
    
    
    ///
    init(astrologyModel: AstrologyModel) {
        self.astrologyModel = astrologyModel
        setupBindings()
    }
    
    
    ///
    init(chart: Chart) {
        self.astrologyModel = AstrologyModel() // Initialize with a default AstrologyModel
        update(with: chart) // Use the existing update method to set up the model based on the chart
        setupBindings() // Set up any required bindings
    }
    
    
    ///
    private func setupBindings() {
        $astrologyModel
            .sink { [weak self] updatedModel in
                self?.aspects = updatedModel.calculateAspects()
                self?.needsRedraw = true // Directly set needsRedraw here
            }
            .store(in: &cancellables)
    }
    
    
    ///
    func update(with chart: Chart) {
        self.planetPositions = chart.planetaryPositions.compactMap { key, value in
            guard let pointKey = Int32(key),
                  let point = Point(rawValue: pointKey), // Safely unwrap pointKey
                  let longitude = Double(value.filter("0123456789.".contains)) else { return nil }

            let position = CGPoint(x: cos(longitude.degreesToRadians), y: sin(longitude.degreesToRadians))
            return PlanetPosition(planet: point, position: position, longitude: CGFloat(longitude))
        }

        self.aspects = chart.aspects.compactMap { aspectString in
            let components = aspectString.split(separator: "-").map(String.init)
            guard components.count == 4,
                  let planet1Key = Int32(components[0]),
                  let planet1 = Point(rawValue: planet1Key),
                  let planet2Key = Int32(components[1]),
                  let planet2 = Point(rawValue: planet2Key),
                  let aspect = Aspect.from(description: components[2]),
                  let angle = Double(components[3]) else {
                return nil
            }

            return AstrologicalAspectData(planet1: planet1, planet2: planet2, aspect: aspect, angleDifference: angle)
        }

        self.needsRedraw = true
        self.objectWillChange.send()
    }

    
    
    // TO DO NOT WORKING
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
                print("TO DO TRANSITS")
                // New functionality to check for taps near transits
//                let tapAngle = calculateAngle(from: center, to: location)
//                if let transitTapped = isTapNearTransit(tapAngle: tapAngle, center: center, tapLocation: location) {
//                    print("Tapped on transit between \(transitTapped.planet1) and \(transitTapped.planet2) with aspect \(transitTapped.aspect)")
//                } else {
//                    print("Tapped in the house area but not on a specific house or transit")
//                }
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
    
//    func isTapNearTransit(tapAngle: Double, center: CGPoint, tapLocation: CGPoint) -> AstrologicalAspectData? {
//        let aspects = calculateAspects()
//        let threshold = 5.0
//        
//        for aspectData in aspects {
//            let planet1Position = calculatePositionForPlanet(aspectData.planet1, at: aspectData.planet1.longitude(using: astrologyModel!), usingAscendant: ascendant(), in: CGRect(x: 0, y: 0, width: center.x * 2, height: center.y * 2))
//            let planet2Position = calculatePositionForPlanet(aspectData.planet2, at: aspectData.planet2.longitude(using: astrologyModel!), usingAscendant: ascendant(), in: CGRect(x: 0, y: 0, width: center.x * 2, height: center.y * 2))
//            
//            let aspectAngle = calculateAngle(from: planet1Position, to: planet2Position)
//            
//            if abs(tapAngle - aspectAngle) <= threshold || abs((tapAngle - 360) - aspectAngle) <= threshold || abs(tapAngle - (aspectAngle - 360)) <= threshold {
//                return aspectData
//            }
//        }
//        
//        return nil
//    }
    ///


    // PLANET
    func isTapNearPlanet(tapLocation: CGPoint, planetPosition: CGPoint, threshold: CGFloat = 20.0) -> Bool {
        let dx = tapLocation.x - planetPosition.x
        let dy = tapLocation.y - planetPosition.y
        let distance = sqrt(dx * dx + dy * dy)
        return distance <= threshold
    }

    
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
//    func longitude(for planet: Point) -> Double {
//        return planet.longitude(using: astrologyModel)
//    }
//    
    
    ///
    func houseCusps() -> [Double] {
        return astrologyModel.houseCusps
    }
    
    
    ///
    func ascendant() -> Double {
        return astrologyModel.ascendant
    }
    

    ///
    func midheaven() -> Double {
        return astrologyModel.midheavenLongitude
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
        return astrologyModel.planetaryPositions.compactMap { point, longitude in
            let position = calculatePositionForPlanet(point, at: longitude, usingAscendant: astrologyModel.ascendant, in: rect)
            return PlanetPosition(planet: point, position: position, longitude: CGFloat(longitude))
        }
    }

    
    ///
    func angleForHouseCusp(houseNumber: Int) -> Double {
        let cuspLongitude = houseNumber >= 1 && houseNumber <= 12 ? astrologyModel.houseCusps[houseNumber - 1] : 0.0
        let ascendantLongitude = astrologyModel.ascendant
        let adjustedLongitude = cuspLongitude - ascendantLongitude
        let angle = (adjustedLongitude.truncatingRemainder(dividingBy: 360) + 360).truncatingRemainder(dividingBy: 360)
        
        return angle
    }
}
