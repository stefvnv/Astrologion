import SwiftUI
import Combine

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
            guard let planet1 = Point(rawValue: capture(1)),
                  let aspectType = Aspect.allCases.first(where: { $0.description.lowercased() == capture(2).lowercased() }),
                  let planet2 = Point(rawValue: capture(3)),
                  let exactAngle = Double(capture(4)),
                  let orb = Double(capture(5)) else {
                return nil
            }
            return AstrologicalAspectData(planet1: planet1, planet2: planet2, aspect: aspectType, exactAngle: exactAngle, orb: orb)
        }
    }


    // MARK: - Following

    func follow() {
        Task {
            try await UserService.follow(uid: user.id)
            user.isFollowed = true
            user.stats?.followers += 1
            NotificationService.uploadNotification(toUid: user.id, type: .follow)
        }
    }
    
    func unfollow() {
        Task {
            try await UserService.unfollow(uid: user.id)
            user.isFollowed = false
            user.stats?.followers -= 1
        }
    }
    
    func checkIfUserIsFollowed() async -> Bool {
        guard !user.isCurrentUser else { return false }
        return await UserService.checkIfUserIsFollowed(uid: user.id)
    }
}
