import SwiftUI

struct OrbitView: View {
    @State private var selectedTab: OrbitTab = .search
    let user: User
    @StateObject var profileViewModel: ProfileViewModel
    
    init(user: User) {
        self.user = user
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                OrbitTabView(selectedTab: $selectedTab, profileViewModel: profileViewModel, userID: user.id)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: ConversationsView(),
                        label: {
                            Image(systemName: "message")
                                .imageScale(.large)
                                .scaledToFit()
                                .foregroundColor(Color.theme.darkBlue)
                        })
                }
            }
            .navigationTitle("Orbit")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct OrbitView_Previews: PreviewProvider {
    static var previews: some View {
        OrbitView(user: dev.user)
    }
}
