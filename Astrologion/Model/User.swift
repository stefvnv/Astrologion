import FirebaseFirestoreSwift
import Firebase

struct User: Identifiable, Codable {
    @DocumentID var uid: String?
    var username: String
    var email: String
    var profileImageUrl: String?
    var fullname: String?
    var bio: String?
    var stats: UserStats?
    var isFollowed: Bool? = false
    var birthDay: Int
    var birthMonth: Int
    var birthYear: Int
    var birthHour: Int
    var birthMinute: Int
    var birthLocation: String
    var latitude: Double
    var longitude: Double
    var chartId: String?
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == id }
    var id: String { return uid ?? NSUUID().uuidString }
}

extension User: Hashable {
    var identifier: String { return id }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(identifier)
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}

struct UserStats: Codable {
    var following: Int
    var posts: Int
    var followers: Int
}
