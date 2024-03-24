import SwiftUI
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var isLoadingChartData = true
    @Published var chartDataErrorMessage: String?
    @Published var chart: Chart? // Use Chart directly rather than through NatalChartViewModel
    private var cancellables: Set<AnyCancellable> = []

    
    init(user: User) {
        self.user = user
        loadUserData()
    }

    
    func loadUserData() {
        Task {
            do {
                async let userStats = UserService.fetchUserStats(uid: user.id)
                async let followedStatus = UserService.checkIfUserIsFollowed(uid: user.id)
                async let chartData = ChartService.shared.fetchChart(for: user.id)

                let (stats, isFollowed, chart) = try await (userStats, followedStatus, chartData)

                DispatchQueue.main.async {
                    self.user.stats = stats
                    self.user.isFollowed = isFollowed
                    self.chart = chart
                    self.isLoadingChartData = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.chartDataErrorMessage = "Failed to load data: \(error.localizedDescription)"
                    self.isLoadingChartData = false
                }
            }
        }
    }

    
    var formattedAscendant: String {
        guard let ascendant = chart?.ascendantSign else { return "Unknown" }
        return ascendant
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
