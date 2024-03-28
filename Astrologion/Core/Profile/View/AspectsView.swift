import SwiftUI

struct AspectsView: View {
    let user: User
    @StateObject var profileViewModel: ProfileViewModel
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Aspects to be displayed here")
            }
        }
    }
}


struct AspectsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Planets displayed here")
    }
}
