import Foundation
import Combine

class TransitsViewModel: ObservableObject {
    @Published var isLoadingChartData: Bool = false
    @Published var currentTransits: [Transit] = []
    @Published var transitDescription: [TransitDescription] = []
    @Published var userChart: Chart?

    private var cancellables = Set<AnyCancellable>()
    private let user: User
    private let astrologyModel: AstrologyModel
    private let londonCoordinates = (latitude: 51.5074, longitude: -0.1278) // TODO: Change to take in current location

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
        guard let userChart = userChart else {
            print("User chart is nil, cannot calculate transits.")
            return
        }
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)
        print("Current date components: \(components)")

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
                let currentPlanetaryPositions = astrologyModel.astrologicalPlanetaryPositions
                print("Current planetary positions: \(currentPlanetaryPositions)")

                DispatchQueue.main.async {
                    self.currentTransits = self.determineTransits(for: currentPlanetaryPositions, with: userChart)
                    print("Current transits count: \(self.currentTransits.count)")
                }
            } catch {
                DispatchQueue.main.async {
                    print("Error calculating current transits: \(error.localizedDescription)")
                }
            }
        }
    }

    private func determineTransits(for currentPositions: [(body: Planet, longitude: Double)], with chart: Chart) -> [Transit] {
        var transits: [Transit] = []

        let excludedPlanets: Set<Planet> = [.Lilith, .NorthNode]

        let natalPlanetaryPositions = chart.planetaryPositions
            .compactMapValues { LongitudeParser.parseLongitude(from: $0) }
            .filter { !excludedPlanets.contains(Planet(rawValue: $0.key)!) } // Filter out excluded planets

        for (transitingPlanet, transitingLongitude) in currentPositions {
            // Skip excluded planets
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
