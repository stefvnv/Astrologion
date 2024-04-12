import SwiftUI

struct MainTabView: View {
    let user: User
    @Binding var selectedIndex: Int
    
    let learningHubViewModel = LearningHubViewModel()
    
    
    init(user: User, selectedIndex: Binding<Int>) {
        self.user = user
        self._selectedIndex = selectedIndex
        
        UITabBar.appearance().barTintColor = UIColor(Color.theme.darkBlue)
     }
    
    
    var body: some View {
            TabView(selection: $selectedIndex) {
                
                // feed
                FeedView()
                    .tabItem {
                        Image(selectedIndex == 0 ? "home-fill" : "home")
                            .environment(\.symbolVariants, selectedIndex == 0 ? .fill : .none)
                    }
                    .onAppear { selectedIndex = 0 }
                    .tag(0)
                
                // learning hub
                LearningHubView(viewModel: learningHubViewModel)
                    .tabItem {
                        Image(selectedIndex == 1 ? "learn-fill" : "learn")
                            .environment(\.symbolVariants, selectedIndex == 1 ? .fill : .none)
                    }
                    .onAppear { selectedIndex = 1 }
                    .tag(1)
                    .environmentObject(learningHubViewModel)
                    
                // transits
                TransitsView(user: user)
                    .tabItem {
                        Image(selectedIndex == 2 ? "transits-fill" : "transits")
                            .environment(\.symbolVariants, selectedIndex == 2 ? .fill : .none)
                    }
                    .onAppear { selectedIndex = 2 }
                    .tag(2)
                
                // orbit
                OrbitView(user: user)
                    .tabItem {
                        Image(selectedIndex == 3 ? "orbit-fill" : "orbit")
                            .environment(\.symbolVariants, selectedIndex == 3 ? .fill : .none)
                    }
                    .onAppear { selectedIndex = 3 }
                    .tag(3)
                
                // profile
                CurrentUserProfileView(user: user)
                    .tabItem {
                        Image(selectedIndex == 4 ? "profile-fill" : "profile")
                            .environment(\.symbolVariants, selectedIndex == 4 ? .fill : .none)
                    }
                    .onAppear { selectedIndex = 4 }
                    .tag(4)
            }
            //.accentColor(Color.theme.darkBlue)
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
