import SwiftUI
import Kingfisher

struct FeedCell: View {
    @ObservedObject var viewModel: FeedCellViewModel
    
    var didLike: Bool { return viewModel.post.didLike ?? false }
    
    init(post: Post) {
        self.viewModel = FeedCellViewModel(post: post)
    }
    
    private var user: User? {
        return viewModel.post.user
    }
    
    private var post: Post {
        return viewModel.post
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CircularProfileImageView(user: user, size: .xSmall)
                
                NavigationLink(value: user) {
                    Text(user?.username ?? "")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.theme.systemBackground)
                }
            }
            .padding([.leading, .bottom], 8)
            
            KFImage(URL(string: post.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: 400)
                .clipped()
                .contentShape(Rectangle())
                      
            HStack(spacing: 16) {
                Button(action: {
                    Task { didLike ? try await viewModel.unlike() : try await viewModel.like() }
                }, label: {
                    Image(systemName: didLike ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(didLike ? .red : Color.theme.systemBackground)
                        .frame(width: 20, height: 20)
                        .font(.system(size: 20))
                        .padding(4)
                })
                
                NavigationLink(destination: CommentsView(post: post)) {
                    Image(systemName: "bubble.right")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .font(.system(size: 20))
                        .padding(4)
                        .foregroundColor(Color.theme.systemBackground)
                }
                
                Button(action: {}, label: {
                    Image(systemName: "paperplane")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .font(.system(size: 20))
                        .padding(4)
                        .foregroundColor(Color.theme.systemBackground)
                })
            }
            .padding(.leading, 4)
            
            NavigationLink(value: SearchViewModelConfig.likes(viewModel.post.id ?? "")) {
                Text(viewModel.likeString)
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.leading, 8)
                    .padding(.bottom, 0.5)
                    .foregroundColor(Color.theme.systemBackground)
            }
            
            HStack {
                Text(post.user?.username ?? "").font(.system(size: 14, weight: .semibold)) +
                    Text(" \(post.caption)")
                    .font(.system(size: 14))
            }.padding(.horizontal, 8)
            
            Text(post.timestamp.timestampString())
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.leading, 8)
                .padding(.top, -2)
        }
    }
}
