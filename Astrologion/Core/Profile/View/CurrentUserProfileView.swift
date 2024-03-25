import SwiftUI

struct CurrentUserProfileView: View {
    let user: User
    @StateObject var viewModel: ProfileViewModel
    @State private var showSettingsSheet = false
    @State private var selectedSettingsOption: SettingsItemModel?
    @State private var showDetail = false

    init(user: User) {
        self.user = user
        _viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ProfileHeaderView(viewModel: viewModel)

                    // Optionally display the NatalChartViewRepresentable
                    if let chart = viewModel.chart {
                        NatalChartViewRepresentable(viewModel: NatalChartViewModel(chart: chart))
                            .frame(height: 600) // Adjust height as needed
                    } else if viewModel.isLoadingChartData {
                        ProgressView("Loading astrological details...")
                    } else {
                        Text("Unable to load chart data.")
                            .foregroundColor(.secondary)
                    }

                    // PostGridView(config: .profile(user)) // Uncomment or replace this with your actual content
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showDetail, destination: {
                Text(selectedSettingsOption?.title ?? "")
            })
            .sheet(isPresented: $showSettingsSheet) {
                SettingsView(selectedOption: $selectedSettingsOption)
                    .presentationDetents([.height(CGFloat(SettingsItemModel.allCases.count * 56))])
                    .presentationDragIndicator(.visible)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        selectedSettingsOption = nil
                        showSettingsSheet.toggle()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
            .onChange(of: selectedSettingsOption) { newValue in
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
