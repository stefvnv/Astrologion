import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @StateObject var viewModel = LoginViewModel()
    @EnvironmentObject var registrationViewModel: RegistrationViewModel
    
    var body: some View {
        NavigationStack{
            VStack {
                Spacer()
                
                AdaptiveImage(light: "instagram_logo_black", dark: "instagram_logo_white", width: 220, height: 100)
                
                VStack(spacing: 8) {
                    TextField("Enter your email", text: $email)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                    
                    SecureField("Password", text: $password)
                        .modifier(TextFieldModifier())
                }
                
                HStack {
                    Spacer()
                    
                    NavigationLink(
                        destination: ResetPasswordView(email: $email),
                        label: {
                            Text("Forgot Password?")
                                .font(.system(size: 13, weight: .semibold))
                                .padding(.top)
                                .padding(.trailing, 28)
                        })
                }
                
                
                Button(action: {
                    Task { try await viewModel.login(withEmail: email, password: password) }
                }, label: {
                    Text("Log In")
                        .modifier(IGButtonModifier())
                })
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                
                VStack(spacing: 24) {
                    HStack {
                        Rectangle()
                            .frame(width:( UIScreen.main.bounds.width / 2) - 40, height: 0.5)
                            .foregroundColor(Color(.separator))
                        
                        Text("OR")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.gray))
                        
                        Rectangle()
                            .frame(width:( UIScreen.main.bounds.width / 2) - 40, height: 0.5)
                            .foregroundColor(Color(.separator))
                    }
                    
                    HStack {
                        Image("facebook_logo")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        Text("Continue with Facebook")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.systemBlue))
                    }
                }
                .padding(.top, 4)
                
                Spacer()
                
                Divider()
                
                NavigationLink {
                    AddEmailView()
                        .environmentObject(registrationViewModel)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                            .font(.system(size: 14))
                        
                        Text("Sign Up")
                            .font(.system(size: 14, weight: .semibold))
                    }
                }
                .padding(.vertical, 16)
            }
        }
    }
}

// MARK: - AuthenticationFormProtocol

extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(RegistrationViewModel())
    }
}
