import SwiftUI

struct CompleteSignUpView: View {
    @EnvironmentObject var registrationViewModel: RegistrationViewModel
    @StateObject private var viewModel = CompleteSignUpViewModel()
    @State private var showSunSign = false
    @State private var showMoonSign = false
    @State private var showAscendant = false
    @State private var showButton = false

    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("Welcome to Astrologion, \(registrationViewModel.username)")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
                .multilineTextAlignment(.center)

//            if showSunSign {
//                Text("Sun Sign: \(viewModel.sunPosition)")
//                    .transition(.opacity)
//                    .animation(.easeIn(duration: 0.3), value: showSunSign)
//            }
//
//            if showMoonSign {
//                Text("Moon Sign: \(viewModel.moonPosition)")
//                    .transition(.opacity)
//                    .animation(.easeIn(duration: 0.3), value: showMoonSign)
//            }
//
//            if showAscendant {
//                Text("Rising Sign: \(viewModel.ascendant)")
//                    .transition(.opacity)
//                    .animation(.easeIn(duration: 0.3), value: showAscendant)
//            }

            //if showButton {
                Button("Complete Sign Up") {
                    Task {
                        do {
                            try await registrationViewModel.createUser()
                        } catch {
                            print("Error during user creation: \(error.localizedDescription)")
                        }
                    }
                //}
                //.modifier(IGButtonModifier())
                //.disabled(!registrationViewModel.formIsValid)
                //.transition(.opacity)
                //.animation(.easeIn(duration: 0.3), value: showButton)
            }
            Spacer()
        }
    }

//    func performAstrologicalCalculations() {
//        let birthDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: registrationViewModel.birthDate)
//        let birthYear = birthDateComponents.year ?? 2000
//        let birthMonth = birthDateComponents.month ?? 1
//        let birthDay = birthDateComponents.day ?? 1
//
//        let birthTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: registrationViewModel.birthTime)
//        let birthHour = birthTimeComponents.hour ?? 0
//        let birthMinute = birthTimeComponents.minute ?? 0
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//            self.showSunSign = true
//            
//            viewModel.calculateAstrologicalDetails(
//                day: birthDay,
//                month: birthMonth,
//                year: birthYear,
//                hour: birthHour,
//                minute: birthMinute,
//                latitude: registrationViewModel.latitude,
//                longitude: registrationViewModel.longitude
//            )
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//                self.showMoonSign = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
//                    self.showAscendant = true
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
//                        self.showButton = true
//                    }
//                }
//            }
//        }
//    }
}

struct CompleteSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteSignUpView().environmentObject(RegistrationViewModel())
    }
}
