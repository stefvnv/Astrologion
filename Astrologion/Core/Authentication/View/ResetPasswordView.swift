import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @Binding private var email: String
    
    init(email: Binding<String>) {
        self._email = email
    }

    var body: some View {
            VStack {
                Text("Astrologion")
                    .font(.custom("PlayfairDisplay-Regular", size: 24))
                    .foregroundColor(Color.theme.yellow)
                
                VStack(spacing: 20) {
                    TextField("Enter your email", text: $email)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                }
                                    
                Button(action: {
                    Task {
                        try await AuthService.shared.sendResetPasswordLink(toEmail: email)
                        dismiss()
                    }
                }, label: {
                    Text("Send Reset Link")
                        .modifier(ButtonModifier())
                })
                
                Spacer()
                
                Button(action: { dismiss() }, label: {
                    HStack {
                        Text("Already have an account?")
                            .font(.system(size: 14))
                        
                        Text("Sign In")
                            .font(.system(size: 14, weight: .semibold))
                    }
                })
            }
            .navigationBarBackButtonHidden(true)
    }
}
