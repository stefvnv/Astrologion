import Foundation
import Firebase
import FirebaseFirestore

class AuthService {
    @Published var user: User?
    @Published var userSession: FirebaseAuth.User?

    static let shared = AuthService()

    
    ///
    init() {
        Task { try await loadUserData() }
    }

    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            self.user = try await UserService.fetchUser(withUid: result.user.uid)
        } catch {
            print("DEBUG: Login failed \(error.localizedDescription)")
        }
    }

    
    @MainActor
    func createUser(email: String, password: String, username: String, birthYear: Int, birthMonth: Int, birthDay: Int, birthHour: Int, birthMinute: Int, latitude: Double, longitude: Double) async throws -> String {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        self.userSession = result.user

        let userData: [String: Any] = [
            "email": email,
            "username": username,
            "uid": result.user.uid,
            "birthYear": birthYear,
            "birthMonth": birthMonth,
            "birthDay": birthDay,
            "birthHour": birthHour,
            "birthMinute": birthMinute,
            "latitude": latitude,
            "longitude": longitude
        ]
        try await Firestore.firestore().collection("users").document(result.user.uid).setData(userData)
        self.user = try await UserService.fetchUser(withUid: result.user.uid)
        return result.user.uid
    }

    
    @MainActor
    func loadUserData() async throws {
        userSession = Auth.auth().currentUser

        if let session = userSession {
            self.user = try await UserService.fetchUser(withUid: session.uid)
        }
    }

    
    ///
    func sendResetPasswordLink(toEmail email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }

    
    ///
    func signout() {
        self.userSession = nil
        self.user = nil
        try? Auth.auth().signOut()
    }
    
    
    ///
    func deleteUser() async throws {
        print("To be implemented")
    }
}
