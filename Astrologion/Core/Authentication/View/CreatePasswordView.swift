import SwiftUI

struct CreatePasswordView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        ZStack {
            Color.theme.darkBlue.edgesIgnoringSafeArea(.all)
            
            VStack() {
                
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 80)
                
                Text("Create a password")
                    .font(.custom("Dosis", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.lavender)
                
                Text("Your password must be at least 6 characters in length.")
                    .font(.custom("Dosis", size: 14))
                    .foregroundColor(Color.theme.lightLavender)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                
                SecureField("Password", text: $viewModel.password)
                    .modifier(TextFieldModifier())
                    .padding(.top)
                
                Spacer()
                
                NavigationLink {
                    CompleteSignUpView()
                } label: {
                    Text("Next")
                        .modifier(ButtonModifier())
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
            }
            .padding()
        }
    }
}

// MARK: - AuthenticationFormProtocol

extension CreatePasswordView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.password.isEmpty && viewModel.password.count > 5
    }
}

struct CreatePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreatePasswordView()
                .environmentObject(RegistrationViewModel())
        }
    }
}
