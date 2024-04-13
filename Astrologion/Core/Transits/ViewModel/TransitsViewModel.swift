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
    
    private func house(for longitude: Double, usingCusps houseCusps: [Double], ascendant: Double) -> Int {
        let adjustedLongitude = (longitude - ascendant + 360).truncatingRemainder(dividingBy: 360)
        let adjustedCusps = houseCusps.map { ($0 - ascendant + 360).truncatingRemainder(dividingBy: 360) }.sorted()
        
        for (index, cusp) in adjustedCusps.enumerated() {
            let nextCuspIndex = (index + 1) % adjustedCusps.count
            let nextCusp = adjustedCusps[nextCuspIndex]
            
            if adjustedLongitude >= cusp && adjustedLongitude < nextCusp {
                return index + 1
            }
        }
        
        return 12
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
        let houseCusps = parseHouseCusps(from: chart)
        let ascendantLongitude = LongitudeParser.parseLongitude(from: chart.houseCusps["House 1"] ?? "0") ?? 0.0
        let house = house(for: longitude, usingCusps: houseCusps, ascendant: ascendantLongitude)
        
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
               natalPlanet != .Ascendant,
               natalPlanet != .Midheaven {
                let foundAspects = findAspects(between: transitingLongitude, and: natalLongitude)
                for aspect in foundAspects {
                    aspectsAndPlanets.append((aspect, natalPlanet))
                }
            }
        }
        
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
