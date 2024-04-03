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
        VStack {
            TransitsTabView(selectedTab: $selectedTab)

            //Divider()

            ScrollView {
                switch selectedTab {
                case .overview:
                    TransitsOverviewView(user: user, transitsViewModel: transitsViewModel)
                default:
                    Text("\(selectedTab.title) content view placeholder")
                        .padding()
                }
            }
        }
        .navigationTitle("Transits")
    }
}
