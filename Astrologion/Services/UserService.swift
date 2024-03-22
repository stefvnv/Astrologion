import Firebase

class UserService {
    
    @Published var currentUser: User?
    
    static let shared = UserService()
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        self.currentUser = user
    }

    static func fetchUser(withUid uid: String) async throws -> User {
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        let user = try snapshot.data(as: User.self)
        return user
    }
}

// MARK: - Following

extension UserService {
    @MainActor
    static func follow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirestoreConstants
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .setData([:])
        
        async let _ = try await FirestoreConstants
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .document(currentUid)
            .setData([:])
        
        async let _ = try await updateUserFeedAfterFollow(followedUid: uid)
    }
    
    @MainActor
    static func unfollow(uid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        async let _ = try await FirestoreConstants
            .FollowingCollection
            .document(currentUid)
            .collection("user-following")
            .document(uid)
            .delete()

        async let _ = try await FirestoreConstants
            .FollowersCollection
            .document(uid)
            .collection("user-followers")
            .document(currentUid)
            .delete()
        
        async let _ = try await updateUserFeedAfterUnfollow(unfollowedUid: uid)
    }
    
    static func checkIfUserIsFollowed(uid: String) async -> Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        let collection = FirestoreConstants.FollowingCollection.document(currentUid).collection("user-following")
        guard let snapshot = try? await collection.document(uid).getDocument() else { return false }
        return snapshot.exists
    }
}

// MARK: - User Stats

extension UserService {
    static func fetchUserStats(uid: String) async throws -> UserStats {
        async let followingSnapshot = try await FirestoreConstants.FollowingCollection.document(uid).collection("user-following").getDocuments()
        let following = try await followingSnapshot.count
        
        async let followerSnapshot = try await FirestoreConstants.FollowersCollection.document(uid).collection("user-followers").getDocuments()
        let followers = try await followerSnapshot.count
        
        async let postSnapshot = try await FirestoreConstants.PostsCollection.whereField("ownerUid", isEqualTo: uid).getDocuments()
        let posts = try await postSnapshot.count
        
        return .init(following: following, posts: posts, followers: followers)
    }
}

// MARK: Feed Updates

extension UserService {
    static func updateUserFeedAfterFollow(followedUid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await FirestoreConstants
            .PostsCollection.whereField("ownerUid", isEqualTo: followedUid)
            .getDocuments()
        
        for document in snapshot.documents {
            try await FirestoreConstants
                .UserCollection
                .document(currentUid)
                .collection("user-feed")
                .document(document.documentID)
                .setData([:])
        }
    }
    
    static func updateUserFeedAfterUnfollow(unfollowedUid: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await FirestoreConstants
            .PostsCollection.whereField("ownerUid", isEqualTo: unfollowedUid)
            .getDocuments()
        
        for document in snapshot.documents {
            try await FirestoreConstants
                .UserCollection
                .document(currentUid)
                .collection("user-feed")
                .document(document.documentID)
                .delete()
        }
    }
}
