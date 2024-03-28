import SwiftUI

struct SummaryView: View {
    let user: User
    @StateObject var profileViewModel: ProfileViewModel
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Summary to be displayed here")
            }
        }
    }
}


struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Summary displayed here")
    }
}
