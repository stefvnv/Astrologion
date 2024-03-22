import Firebase

struct FirestoreConstants {
    private static let Root = Firestore.firestore()
    
    static let UserCollection = Root.collection("users")
    
    static let PostsCollection = Root.collection("posts")
    
    static let FollowersCollection = Root.collection("followers")
    static let FollowingCollection = Root.collection("following")
    
    static let NotificationsCollection = Root.collection("notifications")
    
    static let MessagesCollection = Root.collection("messages")
}
