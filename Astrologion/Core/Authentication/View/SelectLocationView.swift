import SwiftUI

struct SelectLocationView: View {
    @EnvironmentObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showCreatePasswordView = false
    @State private var locationText: String = ""
    
    var body: some View {
        ZStack {
            Color.theme.darkBlue.edgesIgnoringSafeArea(.all)
            
            VStack() {
                
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 80)
                
                Text("Enter your location of birth")
                    .font(.custom("Dosis", size: 24))
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.lavender)
                
                Text("Start typing to find your city of birth.")
                    .font(.custom("Dosis", size: 14))
                    .foregroundColor(Color.theme.lightLavender)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
                
                LocationSearchView(location: $locationText)
                
                Spacer()
                
                Button(action: {
                    viewModel.geocodeLocationName(locationText) {
                        self.showCreatePasswordView = true
                    }
                }) {
                    Text("Next")
                        .modifier(ButtonModifier())
                }
                .disabled(locationText.isEmpty)
                .opacity(locationText.isEmpty ? 0.5 : 1.0)
            }
            .padding()
             
             .navigationDestination(isPresented: $showCreatePasswordView, destination: {
                 CreatePasswordView().environmentObject(viewModel)
             })
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

struct SelectLocationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SelectLocationView().environmentObject(RegistrationViewModel())
        }
    }
}
