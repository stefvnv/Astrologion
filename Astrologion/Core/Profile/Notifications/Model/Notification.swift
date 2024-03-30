import FirebaseFirestoreSwift
import Firebase

struct Notification: Identifiable, Codable {
    @DocumentID var id: String?
    var postId: String?
    let timestamp: Timestamp
    let type: NotificationType
    let uid: String
    
    var isFollowed: Bool? = false
    var post: Post?
    var user: User?
}
