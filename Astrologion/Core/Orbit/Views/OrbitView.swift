import SwiftUI

struct OrbitView: View {
    @StateObject var profileViewModel: ProfileViewModel
    @State private var selectedTab: OrbitTab = .search
    @State private var showNotificationsView = false

    let user: User
    
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
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showNotificationsView.toggle()
                    }) {
                        Image("notifications")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .scaledToFit()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: ConversationsView(),
                        label: {
                            Image("messages")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .scaledToFit()
                                .foregroundColor(Color.theme.darkBlue)
                        })
                }
            }
            .navigationDestination(isPresented: $showNotificationsView) {
                NotificationsView()
            }
            .background(Color.theme.darkBlue)
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
