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
        fullname: "Bruce Wayne",
        bio: "Silent guardian of Gotham",
        stats: UserStats(following: 105, posts: 50, followers: 5000),
        isFollowed: false,
        birthDay: 19,
        birthMonth: 4,
        birthYear: 1970,
        birthHour: 22,
        birthMinute: 47,
        latitude: 40.7128,
        longitude: -74.0060
    )
    
    var users: [User] = [
        .init(
            uid: NSUUID().uuidString,
            username: "venom",
            email: "venom@gmail.com",
            profileImageUrl: "venom-10",
            fullname: "Eddie Brock",
            bio: "Venom",
            stats: UserStats(following: 150, posts: 75, followers: 1200),
            isFollowed: false,
            birthDay: 7,
            birthMonth: 5,
            birthYear: 1985,
            birthHour: 3,
            birthMinute: 20,
            latitude: 34.0522,
            longitude: -118.2437
        ),
        .init(
            uid: NSUUID().uuidString,
            username: "spiderman",
            email: "spiderman@gmail.com",
            profileImageUrl: "spiderman",
            fullname: "Peter Parker",
            bio: "Your friendly neighborhood Spider-Man",
            stats: UserStats(following: 120, posts: 60, followers: 2500),
            isFollowed: true,
            birthDay: 10,
            birthMonth: 8,
            birthYear: 1996,
            birthHour: 22,
            birthMinute: 15,
            latitude: 40.7789,
            longitude: -73.9675
        ),
        .init(
            uid: NSUUID().uuidString,
            username: "blackpanther",
            email: "blackpanther@gmail.com",
            profileImageUrl: "blackpanther-1",
            fullname: "Chadwick Boseman",
            bio: "Wakanda forever!",
            stats: UserStats(following: 180, posts: 95, followers: 4500),
            isFollowed: false,
            birthDay: 29,
            birthMonth: 11,
            birthYear: 1977,
            birthHour: 15,
            birthMinute: 30,
            latitude: -1.2921,
            longitude: 36.8219
        ),
        .init(
            uid: NSUUID().uuidString,
            username: "blackpanther",
            email: "blackpanther@gmail.com",
            profileImageUrl: "blackpanther-1",
            fullname: "Chadwick Boseman",
            bio: "King of Wakanda",
            stats: UserStats(following: 200, posts: 80, followers: 5000),
            isFollowed: false,
            birthDay: 29,
            birthMonth: 11,
            birthYear: 1976,
            birthHour: 12,
            birthMinute: 0,
            latitude: -1.2921,
            longitude: 36.8219
        ),

        .init(
            uid: NSUUID().uuidString,
            username: "ironman",
            email: "ironman@gmail.com",
            profileImageUrl: "ironman-1",
            fullname: "Tony Stark",
            bio: "Genius, billionaire, playboy, philanthropist.",
            stats: UserStats(following: 300, posts: 200, followers: 8000),
            isFollowed: true,
            birthDay: 29,
            birthMonth: 5,
            birthYear: 1970,
            birthHour: 14,
            birthMinute: 50,
            latitude: 34.0522,
            longitude: -118.2437
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
                fullname: "Eddie Brock",
                bio: "Journalist",
                stats: UserStats(following: 150, posts: 75, followers: 1200),
                isFollowed: false,
                birthDay: 7,
                birthMonth: 5,
                birthYear: 1985,
                birthHour: 3,
                birthMinute: 20,
                latitude: 34.0522,
                longitude: -118.2437
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
                fullname: "Bruce Wayne",
                bio: "Silent guardian of Gotham",
                stats: UserStats(following: 105, posts: 50, followers: 5000),
                isFollowed: false,
                birthDay: 19,
                birthMonth: 4,
                birthYear: 1970,
                birthHour: 22,
                birthMinute: 47,
                latitude: 40.7128,
                longitude: -74.0060
            )
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: "ironman",
            caption: "Ironman is probably the best superhero in the Avengers series. Shame he had to die",
            likes: 223,
            imageUrl: "iron-man-1",
            timestamp: Timestamp(date: Date()),
            user: User(
                uid: NSUUID().uuidString,
                username: "ironman",
                email: "ironman@gmail.com",
                profileImageUrl: "iron-man-1",
                fullname: "Tony Stark",
                bio: "Genius, billionaire, playboy, philanthropist.",
                stats: UserStats(following: 300, posts: 200, followers: 8000),
                isFollowed: true,
                birthDay: 29,
                birthMonth: 5,
                birthYear: 1970,
                birthHour: 14,
                birthMinute: 50,
                latitude: 34.0522,
                longitude: -118.2437
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
                uid: NSUUID().uuidString,
                username: "spiderman",
                email: "spiderman@gmail.com",
                profileImageUrl: "spiderman",
                fullname: "Peter Parker",
                bio: "Swinging from one building to another",
                stats: UserStats(following: 230, posts: 100, followers: 3000),
                isFollowed: true,
                birthDay: 10,
                birthMonth: 8,
                birthYear: 1996,
                birthHour: 22,
                birthMinute: 15,
                latitude: 40.7789,
                longitude: -73.9675
            )
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: "batman",
            caption: "The Caped Crusader watches over Gotham",
            likes: 150,
            imageUrl: "batman-night",
            timestamp: Timestamp(date: Date()),
            user: User(
                uid: NSUUID().uuidString,
                username: "batman",
                email: "batman@gmail.com",
                profileImageUrl: "batman",
                fullname: "Bruce Wayne",
                bio: "Vigilante by night, billionaire by day",
                stats: UserStats(following: 105, posts: 51, followers: 5001),
                isFollowed: false,
                birthDay: 19,
                birthMonth: 4,
                birthYear: 1970,
                birthHour: 22,
                birthMinute: 47,
                latitude: 40.7128,
                longitude: -74.0060
            )
        ),
    ]
}
