import SwiftUI

struct ProfileTabView: View {
    @Binding var selectedTab: ProfileTab
    let user: User
    let profileViewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                ForEach(ProfileTab.allCases, id: \.self) { tab in
                    VStack {
                        Button(action: {
                            withAnimation {
                                self.selectedTab = tab
                            }
                        }) {
                            Text(tab.text)
                                .foregroundColor(self.selectedTab == tab ? .black : .gray)
                                .fontWeight(self.selectedTab == tab ? .bold : .regular)
                        }
                        .padding(.vertical) // tap area
                        
                        // underline selected tab
                        if selectedTab == tab {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.black)
                                .transition(.opacity)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .background(Color.white)
            
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
                SummaryView(user: user, profileViewModel: profileViewModel)
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
