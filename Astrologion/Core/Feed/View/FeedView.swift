import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(viewModel.posts) { post in
                        FeedCell(post: post)
                    }
                }
                .padding(.top)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    // logo, TODO: Change to astrologion
                    AdaptiveImage(light: "instagram_logo_black",
                                  dark: "instagram_logo_white",
                                  width: 100, height: 50)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    HStack {
                        
                        // messages TODO: move to orbit section
                        NavigationLink(
                            destination: ConversationsView(),
                            label: {
                                Image(systemName: "paperplane")
                                    .imageScale(.large)
                                    .scaledToFit()
                                    .foregroundColor(Color.theme.systemBackground)
                        })
                    }
                }
            }
            .navigationTitle("Feed")
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
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
