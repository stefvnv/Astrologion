import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @Binding private var email: String
    
    init(email: Binding<String>) {
        self._email = email
    }
    
    var body: some View {
        
        ZStack {
            Color.theme.darkBlue.edgesIgnoringSafeArea(.all)
            
            VStack {
                
                
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 140)
                
                Text("Astrologion")
                    .font(.custom("PlayfairDisplay-Regular", size: 32))
                    .foregroundColor(Color.theme.yellow)
                    .padding(.top, -80)
                
                
                VStack(spacing: 20) {
                    TextField("Email", text: $email)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                }
                
                Spacer()
                
                Button(action: {
                    Task {
                        try await AuthService.shared.sendResetPasswordLink(toEmail: email)
                        dismiss()
                    }
                }, label: {
                    Text("Send Reset Link")
                        .modifier(ButtonModifier())
                })
                
                Divider()
                    .background(Color.theme.lavender)
                    .padding(.bottom, 18)

                Button(action: { dismiss() }, label: {
                    HStack(spacing: 3) {
                        Text("Already have an account?")
                            .font(.custom("Dosis", size: 14))
                            .foregroundColor(Color.theme.yellow)
                        
                        Text("Sign In")
                            .font(.custom("Dosis", size: 14).weight(.semibold))
                            .foregroundColor(Color.theme.yellow)
                    }
                })
                .padding(.bottom, 16)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
