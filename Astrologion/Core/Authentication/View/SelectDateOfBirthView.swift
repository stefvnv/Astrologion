import SwiftUI

struct SelectDateOfBirthView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State private var showTimeOfBirthView = false

    var body: some View {
        VStack(spacing: 12) {
            DatePicker(
                "Select your date of birth",
                selection: $viewModel.birthDate,
                displayedComponents: .date
            )
            .padding()
            
            Button {
                self.showTimeOfBirthView = true
            } label: {
                Text("Next")
                    .modifier(IGButtonModifier())
            }
            Spacer()
        }
        .navigationDestination(isPresented: $showTimeOfBirthView, destination: {
            SelectTimeOfBirthView()
        })
    }
}

struct SelectDateOfBirthView_Previews: PreviewProvider {
    static var previews: some View {
        SelectDateOfBirthView()
            .environmentObject(RegistrationViewModel())
    }
}
