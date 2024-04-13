import SwiftUI
import Kingfisher

struct PostGridView: View {
    private let items = [
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
        GridItem(.flexible(), spacing: 1),
    ]
    private let width = (UIScreen.main.bounds.width / 3) - 2
    
    let config: PostGridConfiguration
    @StateObject var viewModel: PostGridViewModel
    
    init(config: PostGridConfiguration) {
        self.config = config
        self._viewModel = StateObject(wrappedValue: PostGridViewModel(config: config))
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: items, spacing: 2) {
                ForEach(viewModel.posts) { post in
                    NavigationLink(destination: FeedCell(post: post)) {
                        KFImage(URL(string: post.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: width, height: width)
                            .clipped()
                    }
                    .onAppear {
                        guard let index = viewModel.posts.firstIndex(where: { $0.id == post.id }) else { return }
                        if case .explore = config, index == viewModel.posts.count - 1 {
                            viewModel.fetchExplorePagePosts()
                        }
                    }
                }
            }
        }
        .background(Color.theme.darkBlue)
        .navigationDestination(for: Post.self) { post in
            FeedCell(post: post)
        }
    }
}

struct PostGridView_Previews: PreviewProvider {
    static var previews: some View {
        PostGridView(config: .profile(dev.user))
    }
}
