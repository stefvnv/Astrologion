import SwiftUI
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var isLoadingChartData = true
    @Published var chartDataErrorMessage: String?
    @Published var natalChartViewModel: NatalChartViewModel?
    private var cancellables: Set<AnyCancellable> = []
    private let chartService = ChartService.shared

    init(user: User) {
        self.user = user
        loadUserData()
    }


    var formattedAscendant: String {
        guard let ascendantDegree = natalChartViewModel?.astrologyModel.ascendant else { return "Unknown" }
        let ascendantSignAndDegree = natalChartViewModel?.astrologyModel.zodiacSignAndDegree(fromLongitude: ascendantDegree) ?? "Unknown"
        return natalChartViewModel?.astrologyModel.extractZodiacSign(from: ascendantSignAndDegree) ?? "Unknown"
    }


    ///
    func loadUserData() {
        Task {
            do {
                async let userStats = UserService.fetchUserStats(uid: user.id)
                async let followedStatus = UserService.checkIfUserIsFollowed(uid: user.id)
                async let existingChartData = ChartService.shared.fetchChart(for: user.id)

                let (stats, isFollowed, chart) = try await (userStats, followedStatus, existingChartData)

                DispatchQueue.main.async {
                    self.user.stats = stats
                    self.user.isFollowed = isFollowed

                    if let chartData = chart {
                        let astrologyModel = AstrologyModel(from: chartData)
                        self.natalChartViewModel = NatalChartViewModel(astrologyModel: astrologyModel)
                        self.observeNatalChartViewModel()
                    }

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

    private func observeNatalChartViewModel() {
        natalChartViewModel?.$astrologyModel.sink(receiveValue: { [weak self] _ in
            self?.objectWillChange.send()
        }).store(in: &cancellables)
    }
}

// MARK: - Following

extension ProfileViewModel {
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
