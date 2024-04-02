import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showPasswordInputSheet = false
    @State private var showAlert = false
    @State private var errorMessage: String?

    var body: some View {
        List(SettingsItemModel.allCases) { model in
            SettingsRowView(model: model)
                .onTapGesture {
                    if model == .logout {
                        AuthService.shared.signout()
                        dismiss()
                    } else if model == .deleteAccount {
                        showPasswordInputSheet = true
                    }
                }
        }
        .sheet(isPresented: $showPasswordInputSheet) {
            PasswordInputView { password in
                Task {
                    do {
                        try await AuthService.shared.deleteUser(currentPassword: password)
                        dismiss()
                    } catch {
                        errorMessage = error.localizedDescription
                        showAlert = true
                    }
                }
            }
        }
        .alert("Error", isPresented: $showAlert, actions: {
            Button("OK", role: .cancel) { }
        }, message: {
            if let errorMessage = errorMessage {
                Text(errorMessage)
            }
        })
        .navigationTitle("Settings")
        .listStyle(PlainListStyle())
        .padding(.vertical)
    }
}
