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
    private let londonCoordinates = (latitude: 51.5074, longitude: -0.1278)

    private let primaryTransitingPlanets: [Planet] = [
        .Sun, .Moon, .Mercury, .Venus, .Mars, .Jupiter, .Saturn, .Uranus, .Neptune, .Pluto
    ]

    private let inclusiveNatalPoints: [Planet] = [
        .Sun, .Moon, .Mercury, .Venus, .Mars, .Jupiter, .Saturn, .Uranus, .Neptune, .Pluto, .NorthNode, .Lilith, .Ascendant, .Midheaven
    ]

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

    private func house(for longitude: Double, usingCusps houseCusps: [Double]) -> Int {
        // Adjust longitudes to ensure they fall within the 0° to 360° range.
        let adjustedLongitude = longitude.truncatingRemainder(dividingBy: 360)
        let adjustedCusps = houseCusps.map { $0.truncatingRemainder(dividingBy: 360) }

        // Find the house cusp that just precedes the planet's longitude.
        let precedingCuspIndex = adjustedCusps.enumerated().first { index, cusp in
            // Special handling for the transition from Pisces to Aries.
            if cusp < adjustedCusps[0] {
                return adjustedLongitude >= 0 && adjustedLongitude < cusp
            }
            return adjustedLongitude < cusp
        }?.offset

        // Determine the house based on the preceding cusp index.
        if let index = precedingCuspIndex {
            return index == 0 ? 12 : index // Handle the transition between the last and first houses.
        } else {
            // If no preceding cusp is found, the planet is in the last house.
            return 12
        }
    }


    func loadTransitDescription() {
        self.transitDescription = loadTransitData()
    }

    func parseHouseCusps(from chart: Chart) -> [Double] {
        return chart.houseCusps.compactMap { key, value in
            LongitudeParser.parseLongitude(from: value)
        }.sorted()
    }

    func fetchUserChart() {
        isLoadingChartData = true

        Task {
            do {
                let fetchedChart = try await UserService.fetchUserChart(uid: user.uid ?? "")
                DispatchQueue.main.async {
                    self.userChart = fetchedChart
                    print("Successfully fetched chart: \(fetchedChart)")
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
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: currentDate)

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

                var newTransits: [Transit] = []

                let transitingPlanetsDict = astrologyModel.astrologicalPlanetaryPositions
                    .filter { primaryTransitingPlanets.contains($0.body) }
                    .reduce(into: [Planet: Double]()) { dict, entry in
                        dict[entry.body] = entry.longitude
                    }

                let natalPositionsDict = inclusiveNatalPoints.compactMap { planet -> (Planet, Double)? in
                    guard let value = chart.planetaryPositions[planet.rawValue],
                          let longitude = LongitudeParser.parseLongitude(from: value) else {
                        return nil
                    }
                    return (planet, longitude)
                }.reduce(into: [Planet: Double]()) { dict, entry in
                    dict[entry.0] = entry.1
                }

                for (transitingPlanet, transitingLongitude) in transitingPlanetsDict {
                    let sign = self.sign(for: transitingLongitude)
                    let house = self.house(for: transitingLongitude, usingCusps: parseHouseCusps(from: chart))
                    
                    if transitingPlanet == .Pluto {
                        print("Pluto's House: \(house)")
                    }

                    for (natalPlanet, natalLongitude) in natalPositionsDict {
                        let aspects = self.findAspects(between: transitingLongitude, and: natalLongitude)

                        aspects.forEach { aspect in
                            let transit = Transit(
                                planet: transitingPlanet,
                                sign: sign,
                                house: house,
                                aspects: [aspect],
                                natalPlanet: natalPlanet,
                                longitude: transitingLongitude
                            )
                            newTransits.append(transit)
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.currentTransits = newTransits.sorted(by: { $0.planet.rawValue < $1.planet.rawValue })
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
        return ZodiacSign.allCases.first { $0.baseDegree <= longitude && $0.baseDegree + 30 > longitude } ?? .Aries
    }

    private func findAspects(between transitingLongitude: Double, and natalLongitude: Double) -> [Aspect] {
        var aspectsFound: [Aspect] = []

        let angleDifference = abs(transitingLongitude - natalLongitude).truncatingRemainder(dividingBy: 360)
        let normalizedAngle = angleDifference > 180 ? 360 - angleDifference : angleDifference

        for aspect in Aspect.allCases {
            if aspect.isWithinOrb(of: normalizedAngle) {
                aspectsFound.append(aspect)
            }
        }

        return aspectsFound
    }
}
