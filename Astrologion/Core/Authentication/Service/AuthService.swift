import Foundation
import Firebase


class AuthService {
    @Published var user: User?
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService()
    
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
    func createUser(email: String, password: String, username: String, birthYear: Int, birthMonth: Int, birthDay: Int, birthHour: Int, birthMinute: Int, latitude: Double, longitude: Double) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user

            let user = User(
                uid: result.user.uid,
                username: username,
                email: email,
                birthDay: birthDay,
                birthMonth: birthMonth,
                birthYear: birthYear,
                birthHour: birthHour,
                birthMinute: birthMinute,
                latitude: latitude,
                longitude: longitude
            )
            let chart = try await ChartService.shared.createChart(for: result.user.uid, with: user)
            
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
                "longitude": longitude,
                "chartId": chart.id ?? ""
            ]
            try await FirestoreConstants.UserCollection.document(result.user.uid).setData(userData)

            self.user = try await UserService.fetchUser(withUid: result.user.uid)
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
        }
    }


    
    @MainActor
    func loadUserData() async throws {
        userSession = Auth.auth().currentUser
        
        if let session = userSession {
            self.user = try await UserService.fetchUser(withUid: session.uid)
        }
    }
    
    func sendResetPasswordLink(toEmail email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
    
    func signout() {
        self.userSession = nil
        self.user = nil
        try? Auth.auth().signOut()
    }
    
    func deleteUser() async throws {
        print("To be implemented")
    }
}
