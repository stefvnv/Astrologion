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

                if let chart = profileViewModel.userChart {
                    NatalChartViewRepresentable(chart: chart)
                        .frame(height: 600) 
                }
            }
        }
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            print("ProfileView appeared")
        }

    }
}



struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}
