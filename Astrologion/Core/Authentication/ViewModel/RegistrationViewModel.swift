import Foundation
import Combine


class RegistrationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var birthDate: Date = Date()
    @Published var birthTime: Date = Date()
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var emailIsValid = false
    @Published var usernameIsValid = false
    @Published var isLoading = false
    @Published var emailValidationFailed = false
    @Published var usernameValidationFailed = false
    
    private var cancellables = Set<AnyCancellable>()
    
    
    ///
    @MainActor
    func createUser() async throws {
        isLoading = true
        
        let birthDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: birthDate)
        let birthTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: birthTime)
        
        guard let birthYear = birthDateComponents.year, let birthMonth = birthDateComponents.month, let birthDay = birthDateComponents.day,
              let birthHour = birthTimeComponents.hour, let birthMinute = birthTimeComponents.minute else {
            throw CustomError.missingDateComponents
        }
        
        let userId = try await AuthService.shared.createUser(
            email: email, password: password, username: username,
            birthYear: birthYear, birthMonth: birthMonth, birthDay: birthDay,
            birthHour: birthHour, birthMinute: birthMinute,
            latitude: latitude, longitude: longitude
        )
        
        // calculate and save astrology details
        let chart = await calculateAndCreateChart(
            userId: userId, birthYear: birthYear, birthMonth: birthMonth, birthDay: birthDay,
            birthHour: birthHour, birthMinute: birthMinute, latitude: latitude, longitude: longitude
        )
        
        // save chart ID to the user's Firestore document
        if let chartId = chart?.id {
            await AuthService.shared.updateUserChartId(userId: userId, chartId: chartId)
        }
        isLoading = false
    }

    
    
    
    private func calculateAndCreateChart(
        userId: String, birthYear: Int, birthMonth: Int, birthDay: Int,
        birthHour: Int, birthMinute: Int, latitude: Double, longitude: Double
    ) async -> Chart? {
        let astrologyModel = AstrologyModel()
        astrologyModel.initializeEphemeris()

        do {
            try await astrologyModel.calculateAstrologicalDetails(
                day: birthDay, month: birthMonth, year: birthYear,
                hour: birthHour, minute: birthMinute,
                latitude: latitude, longitude: longitude,
                houseSystem: .placidus // Assuming Placidus; adjust as needed
            )

            var chart = astrologyModel.toChart(userId: userId)

            try await ChartService.shared.saveChart(&chart)
            return chart
        } catch {
            print("Failed to create and save chart: \(error.localizedDescription)")
            return nil
        }
    }


    
    @MainActor
    func validateEmail() async throws {
        isLoading = true
        let snapshot = try await FirestoreConstants.UserCollection.whereField("email", isEqualTo: email).getDocuments()
        emailValidationFailed = !snapshot.isEmpty
        emailIsValid = snapshot.isEmpty
        isLoading = false
    }
    
    @MainActor
    func validateUsername() async throws {
        isLoading = true
        let snapshot = try await FirestoreConstants.UserCollection.whereField("username", isEqualTo: username).getDocuments()
        usernameIsValid = snapshot.isEmpty
        isLoading = false
    }
    
    var formIsValid: Bool {
        !username.isEmpty && !password.isEmpty && !email.isEmpty && emailIsValid && usernameIsValid
    }
}
