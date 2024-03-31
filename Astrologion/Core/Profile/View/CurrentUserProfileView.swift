import SwiftUI

struct CurrentUserProfileView: View {
    let user: User
    @State private var selectedTab: ProfileTab = .chart
    @StateObject var profileViewModel: ProfileViewModel
    @State private var showSettingsSheet = false
    @State private var selectedSettingsOption: SettingsItemModel?
    @State private var showDetail = false
    @State private var showNotificationsView = false
    @State private var showConfirmationDialog = false

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
                SettingsView()
                    .presentationDetents([.height(360)])
                    .presentationDragIndicator(.visible)
            }
            .confirmationDialog("Are you sure?", isPresented: $showConfirmationDialog, titleVisibility: .visible) {
                Button("Delete Account", role: .destructive) {
                    Task {
                        do {
                            try await AuthService.shared.deleteUser()
                            // Handle navigation to login or welcome screen here.
                        } catch {
                            print("Failed to delete account")
                        }
                    }
                }
            } message: {
                Text("This will permanently delete your account and all associated data.")
            }
            .onChange(of: selectedSettingsOption) { newValue in
                switch newValue {
                case .logout:
                    AuthService.shared.signout()
                case .deleteAccount:
                    showConfirmationDialog = true
                default:
                    break
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
