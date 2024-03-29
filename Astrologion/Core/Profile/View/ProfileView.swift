import SwiftUI

struct ProfileView: View {
    @State private var selectedTab: ProfileTab = .chart
    @StateObject var profileViewModel: ProfileViewModel
    let user: User

    init(user: User) {
        self.user = user
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 1) {
                ProfileHeaderView(viewModel: profileViewModel)

                ProfileTabView(selectedTab: $selectedTab, user: user, profileViewModel: profileViewModel)
            }
        }
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}
