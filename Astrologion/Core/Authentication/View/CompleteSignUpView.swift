import SwiftUI

struct CompleteSignUpView: View {
    @EnvironmentObject var registrationViewModel: RegistrationViewModel
    @StateObject private var viewModel = CompleteSignUpViewModel()
    
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            
            Image("logo")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.vertical, 50)
            
            Text("Welcome to Astrologion, \n\(registrationViewModel.username)")
                .font(.custom("Dosis", size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color.theme.lavender)
                .padding(.top)
            
            Text("Sun Sign: \(viewModel.sunPosition)")
            Text("Moon Sign: \(viewModel.moonPosition)")
            Text("Ascendant: \(viewModel.ascendant)")
            
            Button("Complete Sign Up") {
                Task {
                    do {
                        try await registrationViewModel.createUser()
                    } catch {
                        print("Error during user creation: \(error.localizedDescription)")
                    }
                }
            }
            Spacer()
        }
    }
}

struct CompleteSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteSignUpView().environmentObject(RegistrationViewModel())
    }
}
