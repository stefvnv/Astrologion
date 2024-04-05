import Foundation
import Combine

class TransitsViewModel: ObservableObject {
    @Published var isLoadingChartData: Bool = false
    @Published var currentTransits: [Transit] = []
    @Published var transitDescription: [TransitDescription] = []
    @Published var userChart: Chart?

    private var tempNewTransits: [Transit] = []

    private var cancellables = Set<AnyCancellable>()
    private let user: User
    private let astrologyModel: AstrologyModel
    private let londonCoordinates = (latitude: 51.5074, longitude: -0.1278)

    init(user: User, astrologyModel: AstrologyModel) {
        self.user = user
        self.astrologyModel = astrologyModel
        fetchUserChart()
        loadTransitDescription()
        
        $userChart
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.getCurrentTransits()
            }
            .store(in: &cancellables)
    }
    
    func loadTransitDescription() {
        self.transitDescription = loadTransitData()
    }

    func parseHouseCusps(from chart: Chart) -> [Double] {
        return chart.houseCusps.compactMap { key, value in
            LongitudeParser.parseLongitude(from: value)
        }.sorted()
    }

    // TODO: Move to common static class since used in both here and profileviewmodel
    func fetchUserChart() {
        isLoadingChartData = true

        Task {
            do {
                let fetchedChart = try await UserService.fetchUserChart(uid: user.uid ?? "")
                DispatchQueue.main.async {
                    self.userChart = fetchedChart
                    print("Successfully fetched chart: \(String(describing: fetchedChart))")
                }
            } catch {
                DispatchQueue.main.async {
                    print("Failed to fetch user chart: \(error.localizedDescription)")
                }
            }
            DispatchQueue.main.async {
                self.isLoadingChartData = false
            }
        }
    }
    

    func getCurrentTransits() {
        guard let chart = userChart else {
            print("User chart is nil, cannot calculate transits.")
            return
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)

        Task {
            do {
                try await astrologyModel.calculateAstrologicalDetails(
                    day: components.day!,
                    month: components.month!,
                    year: components.year!,
                    hour: components.hour!,
                    minute: components.minute!,
                    latitude: londonCoordinates.latitude,
                    longitude: londonCoordinates.longitude,
                    houseSystem: .placidus
                )
                
                // Clear the temporary transits list
                self.tempNewTransits.removeAll()
                
                let currentPlanetaryPositions = astrologyModel.astrologicalPlanetaryPositions
                print("Current planetary positions: \(currentPlanetaryPositions)")
                
                for (planet, longitude) in currentPlanetaryPositions {
                    let sign = self.sign(for: longitude)
                    let house = self.house(for: longitude, usingCusps: parseHouseCusps(from: chart))
                    let aspects = self.findAspects(for: planet, at: longitude, with: currentPlanetaryPositions)
                    
                    // Create a new Transit object
                    let transit = Transit(
                        planet: planet,
                        sign: sign,
                        house: house,
                        aspect: aspects.first ?? .conjunction,
                        natalPlanet: planet,
                        longitude: longitude
                    )
                    
                    // Append the new transit to the temporary list
                    self.tempNewTransits.append(transit)
                }
                
                DispatchQueue.main.async {
                    self.currentTransits = self.tempNewTransits.sorted(by: { $0.planet.rawValue < $1.planet.rawValue })
                    print("Transits updated: \(self.currentTransits)")
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error calculating transits: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func sign(for longitude: Double) -> ZodiacSign {
        return ZodiacSign.allCases.first(where: { $0.baseDegree <= longitude && $0.baseDegree + 30 > longitude }) ?? .Aries
    }

    private func house(for longitude: Double, usingCusps houseCusps: [Double]) -> Int {
        let adjustedLongitude = longitude.truncatingRemainder(dividingBy: 360)
        let index = houseCusps.firstIndex(where: { adjustedLongitude < $0 }) ?? 11
        return (index + 1) % 12 + 1 // This wraps the index to the house number (1-12)
    }
    
    private func findAspects(for planet: Planet, at longitude: Double, with positions: [(Planet, Double)]) -> [Aspect] {
        var aspects: [Aspect] = []
        
        // Define orbs for each aspect type
        let orbs: [Aspect: Double] = [
            .conjunction: 2,
            .sextile: 2,
            .square: 2,
            .trine: 2,
            .opposition: 2
        ]

        for (otherPlanet, otherLongitude) in positions where otherPlanet != planet {
            let angleDifference = abs(longitude - otherLongitude).truncatingRemainder(dividingBy: 360)
            let angle = min(angleDifference, 360 - angleDifference) // Correct for angles greater than 180
            
            // Check each aspect type
            if angle <= orbs[.conjunction]! {
                aspects.append(.conjunction)
            } else if abs(angle - 60) <= orbs[.sextile]! {
                aspects.append(.sextile)
            } else if abs(angle - 90) <= orbs[.square]! {
                aspects.append(.square)
            } else if abs(angle - 120) <= orbs[.trine]! {
                aspects.append(.trine)
            } else if abs(angle - 180) <= orbs[.opposition]! {
                aspects.append(.opposition)
            }
        }
        
        return aspects
    }

    
    
    ///
    
    
    
    

    private func determineTransits(for currentPositions: [(body: Planet, longitude: Double)], with chart: Chart) -> [Transit] {
        var transits: [Transit] = []

        let excludedPlanets: Set<Planet> = [.Lilith, .NorthNode]

        let natalPlanetaryPositions = chart.planetaryPositions
            .compactMapValues { LongitudeParser.parseLongitude(from: $0) }
            .filter { !excludedPlanets.contains(Planet(rawValue: $0.key)!) } // Filter out excluded planets

        for (transitingPlanet, transitingLongitude) in currentPositions {
            guard !excludedPlanets.contains(transitingPlanet) else { continue }

            for (natalPlanetName, natalLongitude) in natalPlanetaryPositions {
                guard let natalPlanet = Planet(rawValue: natalPlanetName),
                      natalPlanet != transitingPlanet else { continue }

                let angleDifference = abs(transitingLongitude - natalLongitude)
                let normalizedAngle = min(angleDifference, 360 - angleDifference)

                if let aspect = Aspect.allCases.first(where: { aspect in
                    normalizedAngle >= aspect.angle - aspect.transitOrb && normalizedAngle <= aspect.angle + aspect.transitOrb
                }) {
                    let currentSign = ZodiacSign.allCases.first { $0.baseDegree <= transitingLongitude && $0.baseDegree + 30 > transitingLongitude } ?? .Aries
                    let currentHouse = astrologyModel.determineHouse(for: transitingLongitude, usingCusps: parseHouseCusps(from: chart))

                    let transit = Transit(planet: transitingPlanet, sign: currentSign, house: currentHouse, aspect: aspect, natalPlanet: natalPlanet, longitude: transitingLongitude)
                    transits.append(transit)
                    print("Transit added: \(transit) aspecting \(natalPlanetName)")
                }
            }
        }
        return transits.sorted(by: { $0.planet.rawValue < $1.planet.rawValue })
    }

} // end
