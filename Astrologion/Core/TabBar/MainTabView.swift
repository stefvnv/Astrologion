import SwiftUI

// TODO: Refactor 
struct MainTabView: View {
    let user: User
    @Binding var selectedIndex: Int
    
    var body: some View {
            TabView(selection: $selectedIndex) {
                
                // feed
                FeedView()
                    .tabItem {
                        Image(systemName: selectedIndex == 0 ? "house.fill" : "house")
                            .environment(\.symbolVariants, selectedIndex == 0 ? .fill : .none)
                    }
                    .onAppear { selectedIndex = 0 }
                    .tag(0)
                
                // TODO: Change to LearningHubView()
//                SearchView()
//                    .tabItem { Image(systemName: "magnifyingglass") }
//                    .onAppear { selectedIndex = 1 }
//                    .tag(1)
                    
                // transits
                TransitsView(user: user)
                    .tabItem {
                        Image(selectedIndex == 2 ? "transitsTab-fill" : "transitsTab")
                            .environment(\.symbolVariants, selectedIndex == 2 ? .fill : .none)

                    }
                    .onAppear { selectedIndex = 2 }
                    .tag(2)
                
                // orbit
                OrbitView(user: user)
                    .tabItem {
                        Image(selectedIndex == 3 ? "orbitTab-fill" : "orbitTab")
                            .environment(\.symbolVariants, selectedIndex == 3 ? .fill : .none)
                    }
                    .onAppear { selectedIndex = 3 }
                    .tag(3)
                
                // profile
                CurrentUserProfileView(user: user)
                    .tabItem {
                        Image(systemName: selectedIndex == 4 ? "person.fill" : "person")
                            .environment(\.symbolVariants, selectedIndex == 4 ? .fill : .none)
                    }
                    .onAppear { selectedIndex = 4 }
                    .tag(4)
            }
            .tint(Color.theme.systemBackground)
    }
    
    var messageLink: some View {
        NavigationLink(
            destination: ConversationsView(),
            label: {
                Image(systemName: "paperplane")
                    .resizable()
                    .font(.system(size: 20, weight: .light))
                    .scaledToFit()
                    .foregroundColor(.black)
            })
    }
}
