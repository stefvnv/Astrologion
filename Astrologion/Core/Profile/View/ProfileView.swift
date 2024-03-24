import SwiftUI

struct ProfileView: View {
    let user: User
    @StateObject var profileViewModel: ProfileViewModel

    init(user: User) {
        self.user = user
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ProfileHeaderView(viewModel: profileViewModel)

                if let natalChartViewModel = profileViewModel.natalChartViewModel {
                    NatalChartViewRepresentable(viewModel: natalChartViewModel)
                        .frame(height: 800)  
                } else if profileViewModel.isLoadingChartData {
                    Text("Loading astrological details...")
                } else {
                    Text("Unable to load chart data.")
                }
            }
            .padding(.top)
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
