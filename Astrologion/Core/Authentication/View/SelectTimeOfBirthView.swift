import SwiftUI

struct SelectTimeOfBirthView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State private var showLocationPickerView = false

    var body: some View {
        VStack(spacing: 12) {
            Text("Select your time of birth")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            DatePicker(
                "Time of Birth",
                selection: $viewModel.birthTime,
                displayedComponents: [.hourAndMinute]
            )
            .padding()

            Button {
                self.showLocationPickerView = true
            } label: {
                Text("Next")
                    .modifier(IGButtonModifier())
            }
            
            Spacer()
        }
        .navigationDestination(isPresented: $showLocationPickerView, destination: {
            SelectLocationView()
        })
    }
}

struct SelectTimeOfBirthView_Previews: PreviewProvider {
    static var previews: some View {
        SelectTimeOfBirthView().environmentObject(RegistrationViewModel())
    }
}
