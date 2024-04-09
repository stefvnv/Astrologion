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
        let adjustedLongitude = longitude.truncatingRemainder(dividingBy: 360)
        let adjustedCusps = houseCusps.map { $0.truncatingRemainder(dividingBy: 360) }

        let precedingCuspIndex = adjustedCusps.enumerated().first { index, cusp in
            if cusp < adjustedCusps[0] {
                return adjustedLongitude >= 0 && adjustedLongitude < cusp
            }
            return adjustedLongitude < cusp
        }?.offset

        if let index = precedingCuspIndex {
            return index == 0 ? 12 : index
        } else {
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

                let ascendantLongitude = chart.houseCusps["House 1"].flatMap(LongitudeParser.parseLongitude)
                let midheavenLongitude = chart.houseCusps["House 10"].flatMap(LongitudeParser.parseLongitude)

                for transitingPlanetEntry in astrologyModel.astrologicalPlanetaryPositions {
                    guard let transitingPlanet = Planet(rawValue: transitingPlanetEntry.body.rawValue),
                          primaryTransitingPlanets.contains(transitingPlanet) else {
                        continue
                    }

                    let transitingLongitude = transitingPlanetEntry.longitude
                    let sign = self.sign(for: transitingLongitude)
                    let house = self.house(for: transitingLongitude, usingCusps: parseHouseCusps(from: chart))

                    var aspects: [Aspect] = []
                    var aspectNatalPlanets: [Planet] = []

                    for (natalPlanetName, natalValue) in chart.planetaryPositions {
                        guard let natalLongitude = LongitudeParser.parseLongitude(from: natalValue),
                              let natalPlanet = Planet(rawValue: natalPlanetName) else {
                            continue
                        }

                        let foundAspects = self.findAspects(between: transitingLongitude, and: natalLongitude)
                        if !foundAspects.isEmpty {
                            aspects.append(contentsOf: foundAspects)
                            aspectNatalPlanets.append(natalPlanet)
                        }
                    }

                    if let ascendantLongitude = ascendantLongitude {
                        let foundAspects = self.findAspects(between: transitingLongitude, and: ascendantLongitude)
                        if !foundAspects.isEmpty {
                            aspects.append(contentsOf: foundAspects)
                            aspectNatalPlanets.append(.Ascendant)
                        }
                    }

                    if let midheavenLongitude = midheavenLongitude {
                        let foundAspects = self.findAspects(between: transitingLongitude, and: midheavenLongitude)
                        if !foundAspects.isEmpty {
                            aspects.append(contentsOf: foundAspects)
                            aspectNatalPlanets.append(.Midheaven)
                        }
                    }

                    if aspects.isEmpty {
                        let transit = Transit(planet: transitingPlanet, sign: sign, house: house, aspects: [], natalPlanet: nil, longitude: transitingLongitude)
                        newTransits.append(transit)
                    } else {
                        for (index, aspect) in aspects.enumerated() {
                            let transit = Transit(planet: transitingPlanet, sign: sign, house: house, aspects: [aspect], natalPlanet: aspectNatalPlanets[index], longitude: transitingLongitude)
                            newTransits.append(transit)
                        }
                    }
                }

                DispatchQueue.main.async {
                    self.currentTransits = newTransits.sorted(by: { $0.planet.rawValue < $1.planet.rawValue })
                    print("Transits updated: \(self.currentTransits)")
                    self.objectWillChange.send()
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
