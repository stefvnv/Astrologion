import SwiftUI

struct ProfileTabView: View {
    @Binding var selectedTab: ProfileTab
    let user: User
    let profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 1) {
                ForEach(ProfileTab.allCases, id: \.self) { tab in
                    VStack {
                        Button(action: {
                            withAnimation {
                                self.selectedTab = tab
                            }
                        }) {
                            Text(tab.text)
                                .font(.custom("Dosis", size: 14))
                                .foregroundColor(self.selectedTab == tab ? Color.theme.yellow : .gray)
                                .fontWeight(self.selectedTab == tab ? .bold : .regular)
                        }
                        .padding(.vertical, 6) // tap area
                        
                        // underline selected tab
                        if selectedTab == tab {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.theme.yellow)
                                .transition(.opacity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .background(Color.theme.darkBlue)

            switch selectedTab {
            case .chart:
                ChartView(user: user, profileViewModel: profileViewModel)
            case .planets:
                PlanetsView(profileViewModel: profileViewModel)
            case .houses:
                HousesView(profileViewModel: profileViewModel)
            case .aspects:
                AspectsView(profileViewModel: profileViewModel)
            case .summary:
                SummaryView(profileViewModel: profileViewModel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}
