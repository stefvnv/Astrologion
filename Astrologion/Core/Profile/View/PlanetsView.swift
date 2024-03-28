import SwiftUI

struct PlanetsView: View {
    let user: User
    @StateObject var profileViewModel: ProfileViewModel
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Text("Planets to be displayed here")
            }
        }
    }
}


struct PlanetsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Planets displayed here")
    }
}
