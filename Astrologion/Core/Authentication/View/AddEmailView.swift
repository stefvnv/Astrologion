import SwiftUI

struct AddEmailView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showCreateUsernameView = false
    
    var body: some View {
        ZStack {
            Color.theme.darkBlue.edgesIgnoringSafeArea(.all)
            
            VStack() {
                
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 80)
                
                Text("Email")
                    .font(.custom("Dosis", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.lavender)
                
                Text("This email will be used to sign in to your account.")
                    .font(.custom("Dosis", size: 14))
                    .foregroundColor(Color.theme.lightLavender)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                
                ZStack(alignment: .trailing) {
                    TextField("Email", text: $viewModel.email)
                        .modifier(TextFieldModifier())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.trailing, 40)
                            .padding(.top, 14)
                    }
                    
                    if viewModel.emailValidationFailed {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemRed))
                            .padding(.trailing, 40)
                    }
                }
                
                if viewModel.emailValidationFailed {
                    Text("This email is already in use. Please login or use a different email.")
                        .font(.custom("Dosis", size: 12))
                        .foregroundColor(Color(.systemRed))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 28)
                }
                
                Spacer()
                
                Button {
                    Task {
                        try await viewModel.validateEmail()
                    }
                } label: {
                    Text("Next")
                        .modifier(ButtonModifier())
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
            }
            .padding()
            
            .navigationBarBackButtonHidden(true)
            .onReceive(viewModel.$emailIsValid, perform: { emailIsValid in
                if emailIsValid {
                    self.showCreateUsernameView.toggle()
                }
            })
            .navigationDestination(isPresented: $showCreateUsernameView, destination: {
                CreateUsernameView()
            })
            .onAppear {
                showCreateUsernameView = false
                viewModel.emailIsValid = false
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .foregroundColor(Color.theme.lightLavender)
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
        }
    }
}

extension AddEmailView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.email.isEmpty
        && viewModel.email.contains("@")
        && viewModel.email.contains(".")
    }
}

struct AddEmailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AddEmailView()
                .environmentObject(RegistrationViewModel())
        }
    }
}
