import SwiftUI

struct HousesView: View {
    let user: User
    @StateObject var profileViewModel: ProfileViewModel
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Houses to be displayed here")
            }
        }
    }
}


struct HousesView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Houses displayed here")
    }
}
