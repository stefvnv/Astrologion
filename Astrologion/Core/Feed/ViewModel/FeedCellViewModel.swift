import SwiftUI
import Firebase

@MainActor
class FeedCellViewModel: ObservableObject {
    @Published var post: Post
    @Published var userChart: Chart?
    @Published var sunSign: String = ""
    @Published var moonSign: String = ""
    @Published var ascendantSign: String = ""
    
    
    ///
    var likeString: String {
        let label = post.likes == 1 ? "like" : "likes"
        return "\(post.likes) \(label)"
    }
    
    
    ///
    init(post: Post) {
        self.post = post
        fetchUserChart()
    }
    
    
    ///
    func fetchUserChart() {
        Task {
            do {
                let fetchedChart = try await UserService.fetchUserChart(uid: post.ownerUid)
                DispatchQueue.main.async {
                    // Safely unwrap fetchedChart
                    if let fetchedChart = fetchedChart {
                        self.userChart = fetchedChart
                        self.sunSign = self.signFromPosition(fetchedChart.planetaryPositions["Sun"])
                        self.moonSign = self.signFromPosition(fetchedChart.planetaryPositions["Moon"])
                        self.ascendantSign = self.signFromPosition(fetchedChart.houseCusps["House 1"])
                    }
                }
            } catch {
                print("Failed to fetch user chart: \(error.localizedDescription)")
            }
        }
    }


    ///
    private func signFromPosition(_ position: String?) -> String {
        guard let positionString = position, let sign = positionString.split(separator: " ").first else { return "Unknown" }
        return String(sign)
    }
    
    
    ///
    func like() async throws {
        self.post.didLike = true
        Task {
            try await PostService.likePost(post)
            self.post.likes += 1
        }
    }
    
    
    ///
    func unlike() async throws {
        self.post.didLike = false
        Task {
            try await PostService.unlikePost(post)
            self.post.likes -= 1
        }
    }
    
    
    ///
    func checkIfUserLikedPost() async throws {
        self.post.didLike = try await PostService.checkIfUserLikedPost(post)
    }
}
