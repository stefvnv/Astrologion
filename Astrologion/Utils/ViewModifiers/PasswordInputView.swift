import SwiftUI

struct PasswordInputView: View {
    @Environment(\.dismiss) var dismiss
    var onDelete: (String) -> Void
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Please enter your password to confirm account deletion:")
            SecureField("Password", text: $password)
                .modifier(TextFieldModifier())
            
            Button("Confirm Deletion") {
                onDelete(password)
                dismiss()
            }
            .foregroundColor(.red)
            .padding()
        }
        .padding()
    }
}
