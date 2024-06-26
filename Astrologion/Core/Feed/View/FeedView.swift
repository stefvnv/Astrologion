import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    init() {
        configureGlobalAppearances()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.darkBlue.edgesIgnoringSafeArea(.all)
                
                if viewModel.posts.isEmpty {
                    GeometryReader { geometry in
                        ScrollView {
                            VStack(spacing: 20) {
                                Spacer(minLength: (geometry.size.height - totalContentHeight) / 2)
                                
                                LazyVStack(alignment: .center, spacing: 10) {
                                    Text("You do not orbit anyone or nobody has posted lately. Go to the ")
                                        .font(.custom("Dosis", size: 15))
                                        .foregroundColor(Color.theme.lightLavender)
                                    
                                    HStack {
                                        Image("orbit")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                        
                                        Text("tab to find people to orbit.")
                                            .font(.custom("Dosis", size: 15))
                                            .foregroundColor(Color.theme.lightLavender)
                                    }
                                }
                                
                                Spacer(minLength: (geometry.size.height - totalContentHeight) / 2)
                            }
                        }
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 32) {
                            ForEach(viewModel.posts) { post in
                                FeedCell(post: post)
                            }
                        }
                        .padding(.top)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Astrologion")
                        .font(.custom("PlayfairDisplay-Regular", size: 24))
                        .foregroundColor(Color.theme.yellow)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(
                        destination: UploadMediaView(),
                        label: {
                            Image(systemName: "plus")
                                .imageScale(.large)
                                .scaledToFit()
                                .foregroundColor(Color.theme.lightLavender)
                        })
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .refreshable {
                Task { try await viewModel.fetchPosts() }
            }
            .navigationDestination(for: User.self) { user in
                ProfileView(user: user)
            }
            .navigationDestination(for: SearchViewModelConfig.self) { config in
                UserListView(config: config)
            }
        }
    }
    
    private var totalContentHeight: CGFloat {
        return 150
    }
    
    private func configureGlobalAppearances() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor(Color.theme.darkBlue)
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.theme.yellow)]
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(Color.theme.darkBlue)
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
