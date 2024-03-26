import SwiftUI

struct ProfileView: View {
    let user: User
    @StateObject var profileViewModel: ProfileViewModel
    @State var natalChartViewModel: NatalChartViewModel? = nil // Changed to optional to handle cases when chart data isn't available

    init(user: User) {
        self.user = user
        _profileViewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ProfileHeaderView(viewModel: profileViewModel)

                if let natalChartViewModel = profileViewModel.natalChartViewModel {
                    NatalChartViewRepresentable(viewModel: $profileViewModel.natalChartViewModel)
                        .frame(height: 600)
                } else if profileViewModel.isLoadingChartData {
                    ProgressView("Loading astrological details...")
                } else {
                    Text("Unable to load chart data.")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.top)
        }
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            profileViewModel.loadUserData()
            if let chart = profileViewModel.chart {
                natalChartViewModel = NatalChartViewModel(chart: chart)
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}
