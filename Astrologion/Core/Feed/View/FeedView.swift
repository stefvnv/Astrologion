import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    init() {
        // Set navigation bar background color
        UINavigationBar.appearance().barTintColor = UIColor(Color.theme.darkBlue)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.theme.darkBlue.edgesIgnoringSafeArea(.top) // Navy-colored background
                
                ScrollView {
                    LazyVStack(spacing: 32) {
                        ForEach(viewModel.posts) { post in
                            FeedCell(post: post)
                        }
                    }
                    .padding(.top)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    
                    Text("Astrologion")
                        .font(.custom("PlayfairDisplay-Regular", size: 24))
                        .foregroundColor(Color.theme.yellow)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    // create post TODO: fix after clicking share button
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
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
