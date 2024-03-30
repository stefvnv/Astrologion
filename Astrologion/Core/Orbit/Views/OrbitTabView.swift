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
                                .font(.system(size: 13))
                                .foregroundColor(self.selectedTab == tab ? .black : .gray)
                                .fontWeight(self.selectedTab == tab ? .bold : .regular)
                        }
                        .padding(.vertical, 6) // tap area
                        
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
