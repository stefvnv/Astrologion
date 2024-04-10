import SwiftUI

struct OrbitTabView: View {
    @Binding var selectedTab: OrbitTab
    @ObservedObject var profileViewModel: ProfileViewModel
    let userID: String
    
    var body: some View {
        VStack {
            HStack(spacing: 1) {
                ForEach(OrbitTab.allCases, id: \.self) { tab in
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
                        .padding(.vertical, 8) // tap area
                        
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
            case .search:
                SearchView()
            case .followers:
                UserListView(config: .followers(userID))
            case .following:
                UserListView(config: .following(userID))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
