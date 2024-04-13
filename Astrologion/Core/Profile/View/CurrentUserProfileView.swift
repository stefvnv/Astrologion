import SwiftUI

struct CurrentUserProfileView: View {
    let user: User
    @State private var selectedTab: ProfileTab = .chart
    @State private var showSettingsSheet = false
    @State private var selectedSettingsOption: SettingsItemModel?
    @State private var showDetail = false
    @State private var showPasswordInputSheet = false
    @State private var errorMessage: String?

    @StateObject var profileViewModel: ProfileViewModel
    @Environment(\.presentationMode) var presentationMode

    init(user: User) {
        self.user = user
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    ProfileHeaderView(viewModel: profileViewModel)

                    ProfileTabView(selectedTab: $selectedTab, user: user, profileViewModel: profileViewModel)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        selectedSettingsOption = nil
                        showSettingsSheet.toggle()
                    }) {
                        Image("settings")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 24, height: 24)
                            .scaledToFit()
                    }
                }
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsView()
                    .presentationDetents([.height(360)])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showPasswordInputSheet) {
                DeleteAccountView { password in
                    Task {
                        do {
                            try await AuthService.shared.deleteUser(currentPassword: password)
                            presentationMode.wrappedValue.dismiss()
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                }
            }
            .onChange(of: selectedSettingsOption) { newValue in
                switch newValue {
                case .logout:
                    AuthService.shared.signout()
                case .deleteAccount:
                    showPasswordInputSheet = true
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
