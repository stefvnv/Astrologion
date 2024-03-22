import SwiftUI
import Firebase
import FirebaseFirestoreSwift

@MainActor
class CommentViewModel: ObservableObject {
    private let post: Post
    private let postId: String
    @Published var comments = [Comment]()
    
    init(post: Post) {
        self.post = post
        self.postId = post.id ?? ""
        
        Task { try await fetchComments() }
    }
    
    func uploadComment(commentText: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let comment = Comment(
            postOwnerUid: post.ownerUid,
            commentText: commentText,
            postId: postId,
            timestamp: Timestamp(),
            commentOwnerUid: uid
        )
        
        guard let commentData = try? Firestore.Encoder().encode(comment) else { return }
        
        let _ = try await FirestoreConstants
            .PostsCollection
            .document(postId)
            .collection("post-comments")
            .addDocument(data: commentData)
        
        self.comments.insert(comment, at: 0)

        NotificationService.uploadNotification(toUid: self.post.ownerUid, type: .comment, post: self.post)
    }
    
    func fetchComments() async throws {
        let query = FirestoreConstants
            .PostsCollection
            .document(postId)
            .collection("post-comments")
            .order(by: "timestamp", descending: true)
        
        guard let snapshot = try? await query.getDocuments() else { return }
        self.comments = snapshot.documents.compactMap({ try? $0.data(as: Comment.self) })
        
        for i in 0 ..< comments.count {
            let comment = comments[i]
            let user = try await UserService.fetchUser(withUid: comment.commentOwnerUid)
            comments[i].user = user
        }
    }
}

// MARK: - Deletion

extension CommentViewModel {
    func deleteAllComments() {
        FirestoreConstants.PostsCollection.getDocuments { snapshot, _ in
            guard let postIDs = snapshot?.documents.compactMap({ $0.documentID }) else { return }
            
            for id in postIDs {
                FirestoreConstants.PostsCollection.document(id).collection("post-comments").getDocuments { snapshot, _ in
                    guard let commentIDs = snapshot?.documents.compactMap({ $0.documentID }) else { return }
                    
                    for commentId in commentIDs {
                        FirestoreConstants.PostsCollection.document(id).collection("post-comments").document(commentId).delete()
                    }
                }
            }
        }
    }
}
