import SwiftUI

struct CreateUsernameView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showSelectDateOfBirthView = false
    
    var body: some View {
        ZStack {
            Color.theme.darkBlue.edgesIgnoringSafeArea(.all)
            
            VStack() {
                
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 80)
                
                Text("Create username")
                    .font(.custom("Dosis", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.lavender)
                
                Text("Pick a username for your new account. You can modify this later.")
                    .font(.custom("Dosis", size: 14))
                    .foregroundColor(Color.theme.lightLavender)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                
                ZStack(alignment: .trailing) {
                    TextField("Username", text: $viewModel.username)
                        .modifier(TextFieldModifier())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.trailing, 40)
                            .padding(.top, 14)
                    }
                    
                    if viewModel.usernameValidationFailed {
                        Image(systemName: "xmark.circle.fill")
                            .imageScale(.large)
                            .fontWeight(.bold)
                            .foregroundColor(Color(.systemRed))
                            .padding(.trailing, 40)
                    }
                }
                
                if viewModel.usernameValidationFailed {
                    Text("This username is already in use. Please choose a different one.")
                        .font(.custom("Dosis", size: 12))
                        .foregroundColor(Color(.systemRed))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 28)
                }
                
                Spacer()
                
                Button {
                    Task {
                        try await viewModel.validateUsername()
                    }
                } label: {
                    Text("Next")
                        .modifier(ButtonModifier())
                }
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0 : 0.5)
            }
            .padding()
            .onReceive(viewModel.$usernameIsValid) { usernameIsValid in
                if usernameIsValid {
                    self.showSelectDateOfBirthView = true
                }
            }
            .navigationDestination(isPresented: $showSelectDateOfBirthView) {
                SelectDateOfBirthView()
            }
            .onAppear {
                viewModel.usernameIsValid = false
            }
        }
        .navigationBarBackButtonHidden(true)
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

// MARK: - AuthenticationFormProtocol

extension CreateUsernameView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !viewModel.username.isEmpty
    }
}

struct CreateUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CreateUsernameView()
                .environmentObject(RegistrationViewModel())
        }
    }
}
