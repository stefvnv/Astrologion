import Foundation
import Combine

class TransitsViewModel: ObservableObject {
    @Published var isLoadingChartData: Bool = false
    @Published var currentTransits: [Transit] = []
    @Published var transitDescription: [TransitDescription] = []
    @Published var transitSummaryDescriptions: [TransitSummaryDescription] = []
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
        loadTransitSummaryDescriptions()

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
    
    func loadTransitSummaryDescriptions() {
        self.transitSummaryDescriptions = loadTransitSummaryData()
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

                for transitingPlanetEntry in astrologyModel.astrologicalPlanetaryPositions {
                    if let transitingPlanet = Planet(rawValue: transitingPlanetEntry.body.rawValue),
                       primaryTransitingPlanets.contains(transitingPlanet) {
                        let transit = createTransit(for: transitingPlanet, with: transitingPlanetEntry.longitude, using: chart)
                        newTransits.append(contentsOf: transit)
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
    
    
    private func createTransit(for planet: Planet, with longitude: Double, using chart: Chart) -> [Transit] {
        let sign = sign(for: longitude)
        let house = house(for: longitude, usingCusps: parseHouseCusps(from: chart))
        var transits: [Transit] = []

        let aspectsAndPlanets = findAspectsForTransitingPlanet(planet, with: longitude, in: chart)
        
        for (aspect, natalPlanet) in aspectsAndPlanets {
            let transit = Transit(planet: planet, sign: sign, house: house, aspects: [aspect], natalPlanet: natalPlanet, longitude: longitude)
            transits.append(transit)
        }
        
        if transits.isEmpty {
            let transit = Transit(planet: planet, sign: sign, house: house, aspects: [], natalPlanet: nil, longitude: longitude)
            transits.append(transit)
        }
        
        return transits
    }
    
    
    private func findAspectsForTransitingPlanet(_ transitingPlanet: Planet, with transitingLongitude: Double, in chart: Chart) -> [(Aspect, Planet)] {
        var aspectsAndPlanets: [(Aspect, Planet)] = []

        for (natalPlanetName, natalValue) in chart.planetaryPositions {
            if let natalLongitude = LongitudeParser.parseLongitude(from: natalValue),
               let natalPlanet = Planet(rawValue: natalPlanetName),
               natalPlanet != .Ascendant, // Exclude Ascendant and Midheaven from planetaryPositions
               natalPlanet != .Midheaven {
                let foundAspects = findAspects(between: transitingLongitude, and: natalLongitude)
                for aspect in foundAspects {
                    aspectsAndPlanets.append((aspect, natalPlanet))
                }
            }
        }

        // Handle aspects with Ascendant and Midheaven separately
        if let ascendantLongitude = chart.houseCusps["House 1"].flatMap(LongitudeParser.parseLongitude) {
            let foundAspects = findAspects(between: transitingLongitude, and: ascendantLongitude)
            for aspect in foundAspects {
                aspectsAndPlanets.append((aspect, .Ascendant))
            }
        }

        if let midheavenLongitude = chart.houseCusps["House 10"].flatMap(LongitudeParser.parseLongitude) {
            let foundAspects = findAspects(between: transitingLongitude, and: midheavenLongitude)
            for aspect in foundAspects {
                aspectsAndPlanets.append((aspect, .Midheaven))
            }
        }

        return aspectsAndPlanets
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
