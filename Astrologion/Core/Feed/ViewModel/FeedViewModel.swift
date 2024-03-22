import SwiftUI
import Firebase

@MainActor
class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    init() {
        Task { try await fetchPosts() }
    }
        
    private func fetchPostIDs() async -> [String] {
        guard let uid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try? await FirestoreConstants.UserCollection.document(uid).collection("user-feed").getDocuments()
        return snapshot?.documents.map({ $0.documentID }) ?? []
    }
    
    func fetchPosts() async throws {
        let postIDs = await fetchPostIDs()
                
        try await withThrowingTaskGroup(of: Post.self, body: { group in
            var posts = [Post]()
            
            for id in postIDs {
                group.addTask { return try await PostService.fetchPost(withId: id) }
            }
            
            for try await post in group {
                posts.append(try await fetchPostUserData(post: post))
            }
            
            self.posts = posts.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
        })
    }
    
    private func fetchPostUserData(post: Post) async throws -> Post {
        var result = post
    
        async let postUser = try await UserService.fetchUser(withUid: post.ownerUid)
        result.user = try await postUser

        return result
    }
}

// fetch all posts
extension FeedViewModel {
    func fetchAllPosts() async throws {
        let snapshot = try? await FirestoreConstants.PostsCollection.order(by: "timestamp", descending: true).getDocuments()
        guard let documents = snapshot?.documents else { return }
        self.posts = documents.compactMap({ try? $0.data(as: Post.self) })
        
        // fetches users in sync
//        for i in 0 ..< posts.count {
//            let post = posts[i]
//            async let user = try await UserService.fetchUser(withUid: post.ownerUid)
//            posts[i].user = try await user
//        }
//
//        self.posts = posts
    }
    
    func fetchAllPostsWithUserData() async throws {
        try await fetchAllPosts()
        
        await withThrowingTaskGroup(of: Void.self, body: { group in
            for post in posts {
                group.addTask { try await self.fetchUserData(forPost: post) }
            }
        })
    }
    
    func fetchUserData(forPost post: Post) async throws {
        guard let indexOfPost = posts.firstIndex(where: { $0.id == post.id }) else { return }
        
        async let user = try await UserService.fetchUser(withUid: post.ownerUid)
        self.posts[indexOfPost].user = try await user
    }
}

// async code but still fetches things sync becuase of for loop
extension FeedViewModel {
    func fetchPostsFromFollowedUsers() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var posts = [Post]()
        
        let snapshot = try? await FirestoreConstants
            .UserCollection
            .document(uid)
            .collection("user-feed")
            .getDocuments()
        
        guard let postIDs = snapshot?.documents.map({ $0.documentID }) else { return }
        
        for id in postIDs {
            let postSnapshot = try? await FirestoreConstants.PostsCollection.document(id).getDocument()
            guard let post = try? postSnapshot?.data(as: Post.self) else { return }
            posts.append(post)
        }
        
        self.posts = posts
    }
}
