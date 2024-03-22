import SwiftUI
import Firebase

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    var user = User(
        uid: NSUUID().uuidString,
        username: "batman",
        email: "batman@gmail.com",
        profileImageUrl: "batman",
        fullname: "Bruce Wayne"
    )
    
    var users: [User] = [
        .init(
            uid: NSUUID().uuidString,
            username: "venom",
            email: "venom@gmail.com",
            profileImageUrl: "venom-10",
            fullname: "Eddie Brock",
            bio: "Venom"
        ),
        .init(
            uid: NSUUID().uuidString,
            username: "spiderman",
            email: "spiderman@gmail.com",
            profileImageUrl: "spiderman",
            fullname: "Peter Parker"
        ),
        .init(
            uid: NSUUID().uuidString,
            username: "batman",
            email: "batman@gmail.com",
            profileImageUrl: "batman",
            fullname: "Bruce Wayne"
        ),
        .init(
            uid: NSUUID().uuidString,
            username: "blackpanther",
            email: "blackpanther@gmail.com",
            profileImageUrl: "blackpanther-1",
            fullname: "Chadwick Bozeman"
        ),
        .init(
            uid: NSUUID().uuidString,
            username: "ironman",
            email: "ironman@gmail.com",
            profileImageUrl: "ironman-1",
            fullname: "Tony Stark"
        ),
    ]
    
    var posts: [Post] = [
        .init(
            id: NSUUID().uuidString,
            ownerUid: "venom",
            caption: "Time to eat",
            likes: 3,
            imageUrl: "venom-2",
            timestamp: Timestamp(date: Date()),
            user: User(
                uid: NSUUID().uuidString,
                username: "venom",
                email: "venom@gmail.com",
                profileImageUrl: "venom-10",
                fullname: "Eddie Brock"
            )
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: "batman",
            caption: "Gotham's Dark Knight",
            likes: 3,
            imageUrl: "batman",
            timestamp: Timestamp(date: Date()),
            user: User(
                uid: NSUUID().uuidString,
                username: "batman",
                email: "batman@gmail.com",
                profileImageUrl: "batman",
                fullname: "Bruce Wayne"
            )
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: "ironman",
            caption: "Ironman is probably the best superhero in the avengers series. Shame he had to die",
            likes: 223,
            imageUrl: "iron-man-1",
            timestamp: Timestamp(date: Date()),
            user: User(
                uid: NSUUID().uuidString,
                username: "ironman",
                email: "ironman@gmail.com",
                profileImageUrl: "iron-man-1",
                fullname: "Tony Stark"
            )
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: "spiderman",
            caption: "Your friendly neighborhood Spider-Man",
            likes: 322,
            imageUrl: "spiderman",
            timestamp: Timestamp(date: Date()),
            user: User(
                uid: "spiderman",
                username: "batman",
                email: "spiderman@gmail.com",
                profileImageUrl: "spiderman",
                fullname: "Peter Parker"
            )
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: "batman",
            caption: "Gotham's Dark Knight",
            likes: 3,
            imageUrl: "batman",
            timestamp: Timestamp(date: Date()),
            user: User(
                uid: NSUUID().uuidString,
                username: "batman",
                email: "batman@gmail.com",
                profileImageUrl: "batman",
                fullname: "Bruce Wayne"
            )
        ),
    ]
}
