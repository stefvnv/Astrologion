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
                
                Text("Astrologion")
                    .font(.custom("PlayfairDisplay-Regular", size: 40))
                    .foregroundColor(Color.theme.yellow)
                
                Spacer()
                
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 40)
                
                Spacer()

                            
                VStack(spacing: 8) {
                    TextField("Enter your email", text: $email)
                        .foregroundColor(Color.theme.lightLavender)
                        .autocapitalization(.none)
                        .modifier(TextFieldModifier())
                    
                    SecureField("Password", text: $password)
                        .foregroundColor(Color.theme.lightLavender)
                        .modifier(TextFieldModifier())
                }
                
                HStack {
                    Spacer()
                    
                    NavigationLink(
                        destination: ResetPasswordView(email: $email),
                        label: {
                            Text("Forgot Password?")
                                .font(.custom("Dosis", size: 14))
                                .padding(.top)
                                .padding(.trailing, 28)
                                .foregroundColor(Color.theme.yellow)
                        })
                }
                                
                Button(action: {
                    Task { try await viewModel.login(withEmail: email, password: password) }
                }, label: {
                    Text("Log In")
                        .modifier(ButtonModifier())
                })
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
                .padding(.top, 4)
                
                Spacer()
                
                Divider()
                    .background(Color.theme.lavender)
                
                NavigationLink {
                    AddEmailView()
                        .environmentObject(registrationViewModel)
                } label: {
                    HStack(spacing: 3) {
                        Text("Don't have an account?")
                            .font(.custom("Dosis", size: 14))
                            .foregroundColor(Color.theme.yellow)
                        
                        Text("Sign Up")
                            .font(.custom("Dosis", size: 14).weight(.semibold))
                            .foregroundColor(Color.theme.yellow)
                    }
                    .foregroundColor(Color.theme.darkBlue)
                }
                .padding(.vertical, 16)
            }
            .background(Color.theme.darkBlue) 
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
