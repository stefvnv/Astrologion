import SwiftUI

struct SelectTimeOfBirthView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State private var showLocationPickerView = false

    var body: some View {
        ZStack {
            Color.theme.darkBlue.edgesIgnoringSafeArea(.all)
            
            VStack() {
                
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 80)

                Text("Select your time of birth")
                    .font(.custom("Dosis", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.lavender)
                
                
                Text("Pick your time of birth. This will determine your astrological details.")
                    .font(.custom("Dosis", size: 14))
                    .foregroundColor(Color.theme.lightLavender)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                
                DatePicker(
                    "Time of Birth",
                    selection: $viewModel.birthTime,
                    displayedComponents: [.hourAndMinute]
                )
                .datePickerStyle(WheelDatePickerStyle())
                .labelsHidden()
                .colorScheme(.dark)
                .padding(.horizontal)
                
                Spacer()
                
                Button {
                    self.showLocationPickerView = true
                } label: {
                    Text("Next")
                        .modifier(ButtonModifier())
                }
            }
            .padding()
            .navigationDestination(isPresented: $showLocationPickerView, destination: {
                SelectLocationView()
            })
        }
    }
}


struct SelectTimeOfBirthView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SelectTimeOfBirthView().environmentObject(RegistrationViewModel())
        }
    }
}
