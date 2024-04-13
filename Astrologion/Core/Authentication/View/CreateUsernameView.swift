import SwiftUI

struct CreateUsernameView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State private var showSelectDateOfBirthView = false

    var body: some View {
        VStack(spacing: 12) {
            Text("Create username")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            Text("Pick a username for your new account. You can always change it later.")
                .font(.footnote)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
            
            ZStack(alignment: .trailing) {
                TextField("Username", text: $viewModel.username)
                    .modifier(TextFieldModifier())
                    .padding(.top)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)

                if viewModel.isLoading {
                    ProgressView()
                        .padding(.trailing, 40)
                        .padding(.top, 14)
                }
            }
            
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

            Spacer()
        }
        .onReceive(viewModel.$usernameIsValid, perform: { usernameIsValid in
            if usernameIsValid {
                self.showSelectDateOfBirthView.toggle()
            }
        })
        .navigationDestination(isPresented: $showSelectDateOfBirthView, destination: {
            SelectDateOfBirthView()
        })
        .onAppear {
            showSelectDateOfBirthView = false
            viewModel.usernameIsValid = false
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
        CreateUsernameView()
            .environmentObject(RegistrationViewModel())
    }
}
