import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showAlert = false
    
    var body: some View {
        List(SettingsItemModel.allCases) { model in
            SettingsRowView(model: model)
                .onTapGesture {
                    if model == .logout {
                        AuthService.shared.signout()
                        dismiss()
                    } else if model == .deleteAccount {
                        showAlert = true
                    }
                }
        }
        .alert("Delete Account", isPresented: $showAlert, actions: {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                Task {
                    do {
                        try await AuthService.shared.deleteUser()
                        // Handle post-deletion navigation or closure
                        dismiss()
                    } catch {
                        // Handle error, show an error message
                    }
                }
            }
        }, message: {
            Text("Are you sure you want to delete your account? This cannot be undone.")
        })
        .navigationTitle("Settings")
        .listStyle(PlainListStyle())
        .padding(.vertical)
    }
}
