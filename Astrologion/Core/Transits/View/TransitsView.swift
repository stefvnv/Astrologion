import SwiftUI

struct TransitsView: View {
    @State private var selectedTab: TransitTab = .overview
    let user: User
    @StateObject private var transitsViewModel: TransitsViewModel

    init(user: User) {
        self.user = user
        _transitsViewModel = StateObject(wrappedValue: TransitsViewModel(user: user, astrologyModel: AstrologyModel()))
    }

    var body: some View {
        ZStack {
            Color.theme.darkBlue.edgesIgnoringSafeArea(.all)
            
            VStack {
                TransitsTabView(selectedTab: $selectedTab)

                ScrollView {
                    switch selectedTab {
                    case .overview:
                        TransitsOverviewView(user: user, transitsViewModel: transitsViewModel, selectedTab: $selectedTab)
                    default:
                        if let planet = Planet(rawValue: selectedTab.rawValue.capitalized) {
                            TransitsPlanetView(user: user, transitsViewModel: transitsViewModel, selectedPlanet: planet)
                        } else {
                            Text("Invalid planet").padding()
                        }
                    }
                }
            }
        }
        .navigationTitle("Transits")
        .onAppear {
            transitsViewModel.fetchUserChart()
        }
    }
}
