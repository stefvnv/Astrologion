import Foundation

class LoginViewModel: ObservableObject {
    func login(withEmail email: String, password: String) async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
}
