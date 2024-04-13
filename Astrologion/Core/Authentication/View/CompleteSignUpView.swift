import SwiftUI

struct CompleteSignUpView: View {
    @EnvironmentObject var registrationViewModel: RegistrationViewModel
    @StateObject private var viewModel = CompleteSignUpViewModel()

    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .frame(width: 100, height: 100)
                .padding(.vertical, 80)
            
            Text("Welcome to")
                .font(.custom("Dosis", size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color.theme.lavender)
                .padding(.top)
            
            Text("Astrologion")
                .font(.custom("PlayfairDisplay-Regular", size: 32))
                .foregroundColor(Color.theme.yellow)
            
            Text("Sun Sign: \(viewModel.sunPosition)")
            Text("Moon Sign: \(viewModel.moonPosition)")
            Text("Ascendant: \(viewModel.ascendant)")
            
            Spacer()
            
            Button("Complete Sign Up") {
                Task {
                    do {
                        try await registrationViewModel.createUser()
                    } catch {
                        print("Error during user creation: \(error.localizedDescription)")
                    }
                }
            }
            .modifier(ButtonModifier())
        }
        .onAppear {
            let details = BirthDetails(
                day: Calendar.current.component(.day, from: registrationViewModel.birthDate),
                month: Calendar.current.component(.month, from: registrationViewModel.birthDate),
                year: Calendar.current.component(.year, from: registrationViewModel.birthDate),
                hour: Calendar.current.component(.hour, from: registrationViewModel.birthTime),
                minute: Calendar.current.component(.minute, from: registrationViewModel.birthTime),
                latitude: registrationViewModel.latitude,
                longitude: registrationViewModel.longitude
            )
            viewModel.performAstrologicalCalculations(with: details)
        }
    }
}
