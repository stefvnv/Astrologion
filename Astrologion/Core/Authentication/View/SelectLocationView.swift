import SwiftUI

struct SelectLocationView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State private var showCreatePasswordView = false
    @State private var locationText: String = ""
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Enter your location of birth")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top)
            
            LocationSearchView(location: $locationText)
            
            Button(action: {
                viewModel.geocodeLocationName(locationText) {
                    self.showCreatePasswordView = true
                }
            }) {
                Text("Next")
                    .modifier(IGButtonModifier())
            }
            .disabled(locationText.isEmpty)
            .opacity(locationText.isEmpty ? 0.5 : 1.0)
            
            Spacer()
        }
        .navigationDestination(isPresented: $showCreatePasswordView, destination: {
            CreatePasswordView().environmentObject(viewModel)
        })
    }
}
