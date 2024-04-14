import SwiftUI

struct SummaryView: View {
    @ObservedObject var profileViewModel: ProfileViewModel

    var body: some View {
        ZStack {
            Color.theme.lightLavender.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack {
                    
                    // TODO: Add ruler
                    
                    ElementSummaryView(profileViewModel: profileViewModel) // elements
                    ModalitySummaryView(profileViewModel: profileViewModel) // modalities
                    PolaritySummaryView(profileViewModel: profileViewModel) // polarity
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            profileViewModel.fetchUserChart()
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(profileViewModel: ProfileViewModel(user: dev.user))
    }
}
