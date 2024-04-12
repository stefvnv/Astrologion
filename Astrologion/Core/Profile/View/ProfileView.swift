import SwiftUI

struct ProfileView: View {
    @State private var selectedTab: ProfileTab = .chart
    @StateObject var profileViewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode

    let user: User

    init(user: User) {
        self.user = user
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ProfileHeaderView(viewModel: profileViewModel)

                ProfileTabView(selectedTab: $selectedTab, user: user, profileViewModel: profileViewModel)
            }
        }
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }
    
    var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(Color.theme.lightLavender)
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}
