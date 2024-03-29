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
