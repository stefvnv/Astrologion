import SwiftUI

struct CompleteSignUpView: View {
    @EnvironmentObject var registrationViewModel: RegistrationViewModel
    @StateObject private var viewModel = CompleteSignUpViewModel()
    @State private var sunOpacity = 0.0
    @State private var moonOpacity = 0.0
    @State private var ascendantOpacity = 0.0
    @State private var buttonOpacity = 0.0
    
    var body: some View {
        ZStack {
            Color.theme.darkBlue.edgesIgnoringSafeArea(.all)
            
            // logo
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 80)
               
                
            // welcome to astrologion text
            VStack {
                Text("Hi \(registrationViewModel.username), welcome to")
                    .font(.custom("Dosis", size: 20))
                    .foregroundColor(Color.theme.lightLavender)
                    .padding(.top, -20)
                
                Text("Astrologion")
                    .font(.custom("PlayfairDisplay-Regular", size: 34))
                    .foregroundColor(Color.theme.yellow)
            }
            .padding(.top, -20)
            .padding(.bottom, 90)

                
            // sun, moon, asc
            VStack {
                HStack {
                    Image("sun-registration")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text(viewModel.sunPosition)
                        .font(.custom("Dosis", size: 24))
                        .foregroundColor(Color.theme.lightLavender)
                }
                .opacity(sunOpacity)
                .padding()

                HStack {
                    Image("moon-registration")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text(viewModel.moonPosition)
                        .font(.custom("Dosis", size: 24))
                        .foregroundColor(Color.theme.lightLavender)
                }
                .opacity(moonOpacity)
                .padding()


                HStack {
                    Image("ascendant-registration")
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text(viewModel.ascendant)
                        .font(.custom("Dosis", size: 24))
                        .foregroundColor(Color.theme.lightLavender)
                }
                .opacity(ascendantOpacity)
                .padding()

            }

                Spacer()

                Button("Enter") {
                    Task {
                        do {
                            try await registrationViewModel.createUser()
                        } catch {
                            print("Error during user creation: \(error.localizedDescription)")
                        }
                    }
                }
                .modifier(ButtonModifier())
                .opacity(buttonOpacity)
                .disabled(buttonOpacity < 1)
            }
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
        .onChange(of: viewModel.isDataReady) { isReady in
            if isReady {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation(.easeIn(duration: 2)) {
                        sunOpacity = 1.0
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation(.easeIn(duration: 2)) {
                        moonOpacity = 1.0
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                    withAnimation(.easeIn(duration: 2)) {
                        ascendantOpacity = 1.0
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                    withAnimation(.easeIn(duration: 2)) {
                        buttonOpacity = 1.0 
                    }
                }
            }
        }
    }
}

struct CompleteSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        CompleteSignUpView().environmentObject(RegistrationViewModel())
    }
}
