import Foundation

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
    
    
    @MainActor
    func createUser() async throws {
        let birthDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: birthDate)
        guard let birthYear = birthDateComponents.year,
              let birthMonth = birthDateComponents.month,
              let birthDay = birthDateComponents.day else {
            throw CustomError.missingDateComponents
        }

        // Extracting time components
        let birthTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: birthTime)
        guard let birthHour = birthTimeComponents.hour,
              let birthMinute = birthTimeComponents.minute else {
            throw CustomError.missingTimeComponents
        }

        try await AuthService.shared.createUser(
            email: email,
            password: password,
            username: username,
            birthYear: birthYear,
            birthMonth: birthMonth,
            birthDay: birthDay,
            birthHour: birthHour,
            birthMinute: birthMinute,
            latitude: latitude,
            longitude: longitude
        )
    }

    
    
    @MainActor
    func validateEmail() async throws {
        self.isLoading = true
        self.emailValidationFailed = false
        
        let snapshot = try await FirestoreConstants
            .UserCollection
            .whereField("email", isEqualTo: email)
            .getDocuments()
        
        self.emailValidationFailed = !snapshot.isEmpty
        self.emailIsValid = snapshot.isEmpty
        
        self.isLoading = false
    }
    
    @MainActor
    func validateUsername() async throws {
        self.isLoading = true
        
        let snapshot = try await FirestoreConstants
            .UserCollection
            .whereField("username", isEqualTo: username)
            .getDocuments()
        
        self.usernameIsValid = snapshot.isEmpty
        self.isLoading = false
    }
    
    var formIsValid: Bool {
        !username.isEmpty && !password.isEmpty && !email.isEmpty && emailIsValid && usernameIsValid
    }
}
