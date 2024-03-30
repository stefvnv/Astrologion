import SwiftUI

struct CurrentUserProfileView: View {
    let user: User
    @State private var selectedTab: ProfileTab = .chart
    @StateObject var profileViewModel: ProfileViewModel
    @State private var showSettingsSheet = false
    @State private var selectedSettingsOption: SettingsItemModel?
    @State private var showDetail = false
    @State private var showNotificationsView = false

    init(user: User) {
        self.user = user
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 1) {
                    ProfileHeaderView(viewModel: profileViewModel)

                    ProfileTabView(selectedTab: $selectedTab, user: user, profileViewModel: profileViewModel)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showNotificationsView.toggle()
                    }) {
                        Image(systemName: "bell")
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        selectedSettingsOption = nil
                        showSettingsSheet.toggle()
                    }) {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
            .navigationDestination(isPresented: $showNotificationsView) {
                NotificationsView()
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsView(selectedOption: $selectedSettingsOption)
                    .presentationDetents([.height(CGFloat(SettingsItemModel.allCases.count * 56))])
                    .presentationDragIndicator(.visible)
            }
            .onChange(of: selectedSettingsOption) { newValue, _ in
                guard let option = newValue else { return }

                if option != .logout {
                    self.showDetail.toggle()
                } else {
                    AuthService.shared.signout()
                }
            }
        }
    }
}

struct CurrentUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileView(user: dev.user)
    }
}
