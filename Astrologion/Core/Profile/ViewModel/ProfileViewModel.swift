import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var userChart: Chart?
    @Published var isLoadingChartData: Bool = false
    
    
    ///
    init(user: User) {
        self.user = user
        fetchUserChart()
    }
    
    
    /// Extracts sun property
    var sunSign: String {
        signFromPosition(userChart?.planetaryPositions["Sun"])
    }
    
    
    /// Extracts moon property
    var moonSign: String {
        signFromPosition(userChart?.planetaryPositions["Moon"])
    }
    
    
    /// Extracts ascendant property
    var ascendantSign: String {
        signFromPosition(userChart?.houseCusps["House 1"])
    }
    
    
    ///
    var elementSummaryData: [ElementSummary] {
        let percentages = calculateElementPercentages()
        return percentages.map { ElementSummary(element: $0.key, percentage: $0.value) }
    }
    
    
    ///
    public func signFromPosition(_ position: String?) -> String {
        guard let positionString = position, let sign = positionString.split(separator: " ").first else { return "Unknown" }
        return String(sign)
    }

    
    ///
    func fetchUserChart() {
        isLoadingChartData = true

        Task {
            do {
                let fetchedChart = try await UserService.fetchUserChart(uid: user.uid ?? "")
                self.userChart = fetchedChart
                print("Successfully fetched chart: \(String(describing: fetchedChart))")
            } catch {
                print("Failed to fetch user chart: \(error.localizedDescription)")
            }
            self.isLoadingChartData = false
        }
    }
    
    
    ///
    func parseAspects(from chart: Chart?) -> [AstrologicalAspectData] {
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
    
    // MARK: - Summary Tab
    
    ///
    func calculateElementPercentages() -> [Element: CGFloat] {
        guard let chart = userChart else { return [:] }

        // initialize counts
        var elementCounts: [Element: Int] = [.fire: 0, .earth: 0, .air: 0, .water: 0]

        // count each element in planetary positions
        for position in chart.planetaryPositions.values {
            if let zodiacSign = ZodiacSign(rawValue: String(position.split(separator: " ").first ?? "")) {
                elementCounts[zodiacSign.element, default: 0] += 1
            }
        }

        // calculate total counts
        let totalCount = elementCounts.values.reduce(0, +)

        // convert to percentage
        var elementPercentages: [Element: CGFloat] = [:]
        for (element, count) in elementCounts {
            elementPercentages[element] = CGFloat(count) / CGFloat(totalCount)
        }
        return elementPercentages
    }
    
    
    ///
    func calculateModalityPercentages() -> [Modality: CGFloat] {
        guard let chart = userChart else { return [:] }

        var modalityCounts: [Modality: Int] = [.cardinal: 0, .fixed: 0, .mutable: 0]

        // count each modality in the planetary positions
        for position in chart.planetaryPositions.values {
            if let zodiacSign = ZodiacSign(rawValue: String(position.split(separator: " ").first ?? "")) {
                modalityCounts[zodiacSign.modality, default: 0] += 1
            }
        }

        // count each modality in house cusps
        for cusp in chart.houseCusps.values {
            if let zodiacSign = ZodiacSign(rawValue: String(cusp.split(separator: " ").first ?? "")) {
                modalityCounts[zodiacSign.modality, default: 0] += 1
            }
        }

        // calculate total counts
        let totalCount = modalityCounts.values.reduce(0, +)

        // convert to percentage
        var modalityPercentages: [Modality: CGFloat] = [:]
        for (modality, count) in modalityCounts {
            modalityPercentages[modality] = CGFloat(count) / CGFloat(totalCount)
        }
        return modalityPercentages
    }
    
    
    ///
    func calculatePolarityPercentages() -> [Polarity: CGFloat] {
        guard let chart = userChart else { return [:] }

        var polarityCounts: [Polarity: Int] = [.yin: 0, .yang: 0]

        // count each polarity in planetary positions
        for position in chart.planetaryPositions.values {
            if let zodiacSign = ZodiacSign(rawValue: String(position.split(separator: " ").first ?? "")) {
                polarityCounts[zodiacSign.polarity, default: 0] += 1
            }
        }

        // calculate total counts
        let totalCount = polarityCounts.values.reduce(0, +)

        // convert to percentage
        var polarityPercentages: [Polarity: CGFloat] = [:]
        for (polarity, count) in polarityCounts {
            polarityPercentages[polarity] = CGFloat(count) / CGFloat(totalCount)
        }
        return polarityPercentages
    }



    // MARK: - Following

    ///
    func follow() {
        Task {
            try await UserService.follow(uid: user.id)
            user.isFollowed = true
            user.stats?.followers += 1
            NotificationService.uploadNotification(toUid: user.id, type: .follow)
        }
    }
    
    
    ///
    func unfollow() {
        Task {
            try await UserService.unfollow(uid: user.id)
            user.isFollowed = false
            user.stats?.followers -= 1
        }
    }
    
    
    ///
    func checkIfUserIsFollowed() async -> Bool {
        guard !user.isCurrentUser else { return false }
        return await UserService.checkIfUserIsFollowed(uid: user.id)
    }
}
