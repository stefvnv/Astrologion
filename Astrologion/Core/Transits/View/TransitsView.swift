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
            // Horizontal scroll view for tabs
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(TransitTab.allCases, id: \.self) { tab in
                        Button(action: {
                            withAnimation { self.selectedTab = tab }
                        }) {
                            Text(tab.title)
                                .padding()
                                .frame(minWidth: 100)
                                .background(selectedTab == tab ? Color.blue : Color.gray.opacity(0.2))
                                .foregroundColor(selectedTab == tab ? .white : .black)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
            }

            Divider()

            // Vertical scroll view for the content of the selected tab
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
