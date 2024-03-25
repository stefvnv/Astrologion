import SwiftUI
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var isLoadingChartData = true
    @Published var chartDataErrorMessage: String?
    @Published var natalChartViewModel: NatalChartViewModel?
    private var cancellables: Set<AnyCancellable> = []
    
    
    @Published var chart: Chart? {
        didSet {
            if let newChart = chart {
                print("Passing Chart to NatalChartViewModel: \(newChart)")
                natalChartViewModel = NatalChartViewModel(chart: newChart)
            }
        }
    }


    ///
    init(user: User) {
        self.user = user
        loadUserData()
    }

    
    ///
    func loadUserData() {
        Task {
            do {
                async let userStats = UserService.fetchUserStats(uid: user.id)
                async let followedStatus = UserService.checkIfUserIsFollowed(uid: user.id)
                async let chartData = ChartService.shared.fetchChart(for: user.id)

                let (stats, isFollowed, chart) = try await (userStats, followedStatus, chartData)
                
                print("Fetched Chart Data: \(String(describing: chart))") // Logging fetched chart data

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
