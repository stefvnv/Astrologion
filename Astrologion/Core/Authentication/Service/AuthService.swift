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

        // Create a user instance for chart creation
        let newUser = User(uid: result.user.uid, username: username, email: email, birthDay: birthDay, birthMonth: birthMonth, birthYear: birthYear, birthHour: birthHour, birthMinute: birthMinute, latitude: latitude, longitude: longitude, chartId: nil)

        // Create and save the chart
        let chart = try await ChartService.shared.createChart(for: newUser.uid!, with: newUser)

        // Prepare userData with chartId included
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
            "chartId": chart.id!
        ]

        // Save user data with chartId to Firestore
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


extension AuthService {
    
    @MainActor
    func updateUserChartId(userId: String, chartId: String) async {
        // Reference to the user's document in the Firestore "users" collection
        let userRef = Firestore.firestore().collection("users").document(userId)
        
        // Update the user's document with the chartId
        do {
            try await userRef.updateData(["chartId": chartId])
            print("Successfully updated user with chartId: \(chartId)")
        } catch let error {
            print("Error updating user with chartId: \(error.localizedDescription)")
        }
    }
}
