import Foundation
import Firebase
import FirebaseFirestoreSwift

struct PostService {
    
    static func uploadPost(_ post: Post) async throws {
        guard let postData = try? Firestore.Encoder().encode(post) else { return }
        let ref = try await FirestoreConstants.PostsCollection.addDocument(data: postData)
        try await updateUserFeedsAfterPost(postId: ref.documentID)
    }
    
    static func fetchPost(withId id: String) async throws -> Post {
        let postSnapshot = try await FirestoreConstants.PostsCollection.document(id).getDocument()
        let post = try postSnapshot.data(as: Post.self)
        return post
    }
    
    static func fetchUserPosts(user: User) async throws -> [Post] {
        let snapshot = try await FirestoreConstants.PostsCollection.whereField("ownerUid", isEqualTo: user.id).getDocuments()
        var posts = snapshot.documents.compactMap({try? $0.data(as: Post.self )})
        
        for i in 0 ..< posts.count {
            posts[i].user = user
        }
        
        return posts
    }
}

// MARK: - Likes

extension PostService {
    static func likePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postId = post.id else { return }
        
        async let _ = try await FirestoreConstants.PostsCollection.document(postId).collection("post-likes").document(uid).setData([:])
        async let _ = try await FirestoreConstants.PostsCollection.document(postId).updateData(["likes": post.likes + 1])
        async let _ = try await FirestoreConstants.UserCollection.document(uid).collection("user-likes").document(postId).setData([:])
        
        async let _ = NotificationService.uploadNotification(toUid: post.ownerUid, type: .like, post: post)
    }
    
    static func unlikePost(_ post: Post) async throws {
        guard post.likes > 0 else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postId = post.id else { return }
        
        async let _ = try await FirestoreConstants.PostsCollection.document(postId).collection("post-likes").document(uid).delete()
        async let _ = try await FirestoreConstants.UserCollection.document(uid).collection("user-likes").document(postId).delete()
        async let _ = try await FirestoreConstants.PostsCollection.document(postId).updateData(["likes": post.likes - 1])
        
        async let _ = NotificationService.deleteNotification(toUid: uid, type: .like, postId: postId)
    }
    
    static func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        guard let postId = post.id else { return false }
        
        let snapshot = try await FirestoreConstants.UserCollection.document(uid).collection("user-likes").document(postId).getDocument()
        return snapshot.exists
    }
}

// MARK: - Feed Updates

extension PostService {
    private static func updateUserFeedsAfterPost(postId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let followersSnapshot = try await FirestoreConstants.FollowersCollection.document(uid).collection("user-followers").getDocuments()
        
        for document in followersSnapshot.documents {
            try await FirestoreConstants
                .UserCollection
                .document(document.documentID)
                .collection("user-feed")
                .document(postId).setData([:])
        }
        
        try await FirestoreConstants.UserCollection.document(uid).collection("user-feed").document(postId).setData([:])
    }
}

