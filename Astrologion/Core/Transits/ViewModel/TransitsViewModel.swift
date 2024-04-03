import Foundation
import Combine

class TransitsViewModel: ObservableObject {
    @Published var currentTransits: [Transit] = []
    @Published var userChart: Chart?
    @Published var isLoadingChartData: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private let user: User
    private let astrologyModel: AstrologyModel
    
    private let londonCoordinates = (latitude: 51.5074, longitude: -0.1278) // TODO: Change to take
    
    
    init(user: User, astrologyModel: AstrologyModel) {
        self.user = user
        self.astrologyModel = astrologyModel
        fetchUserChart()
        
        // Set up a subscriber to call getCurrentTransits when userChart is updated
        $userChart
            .receive(on: DispatchQueue.main)
            .compactMap { $0 } // Filter out nil values
            .sink { [weak self] _ in
                self?.getCurrentTransits()
            }
            .store(in: &cancellables)
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
                    houseSystem: .placidus // Replace with user's preferred house system if necessary
                )

                let currentPlanetaryPositions = astrologyModel.astrologicalPlanetaryPositions
                print("Current planetary positions: \(currentPlanetaryPositions)")

                // Ensure the update happens on the main thread
                DispatchQueue.main.async {
                    self.currentTransits = self.determineTransits(for: currentPlanetaryPositions, with: userChart)
                    print("Current transits count: \(self.currentTransits.count)")
                }
            } catch {
                // Ensure the error is printed on the main thread
                DispatchQueue.main.async {
                    print("Error calculating current transits: \(error.localizedDescription)")
                }
            }
        }
    }


    private func determineTransits(for currentPositions: [(body: Planet, longitude: Double)], with chart: Chart) -> [Transit] {
        var transits: [Transit] = []
        
        // Parse house cusps from the natal chart
        let cusps = parseHouseCusps(from: chart)
        print("Parsed house cusps: \(cusps)")

        for (planet, currentLongitude) in currentPositions {
            // Skip Ascendant, Midheaven, Lilith, and North Node
            if planet == .Ascendant || planet == .Midheaven || planet == .Lilith || planet == .NorthNode {
                print("Skipping \(planet.rawValue)")
                continue
            }

            // Determine the zodiac sign based on the current longitude
            let currentSign = ZodiacSign.allCases.first { $0.baseDegree <= currentLongitude && $0.baseDegree + 30 > currentLongitude } ?? .Aries
            print("Processing \(planet.rawValue) at longitude \(currentLongitude), determined sign: \(currentSign.rawValue)")

            // Determine the house based on the current longitude and the natal chart's house cusps
            let currentHouse = astrologyModel.determineHouse(for: currentLongitude, usingCusps: cusps)
            print("Determined house for \(planet.rawValue): \(currentHouse)")

            // Find aspects between the current planet position and natal chart positions (This is a simplified example)
            let aspect = Aspect.conjunction // Placeholder for actual aspect calculation

            // Create a Transit object with the determined values
            let transit = Transit(planet: planet, sign: currentSign, house: currentHouse, aspect: aspect)
            print("Created transit: \(transit)")

            transits.append(transit)
        }

        return transits.sorted(by: { $0.planet.rawValue < $1.planet.rawValue })
    }





} // end
