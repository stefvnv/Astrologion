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
    
    // TODO: Fix structure (figma)
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CircularProfileImageView(user: viewModel.post.user, size: .xSmall)
                
                VStack(alignment: .leading) {
                    NavigationLink(value: viewModel.post.user) {
                        Text(viewModel.post.user?.username ?? "")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.theme.lightLavender)
                    }
                    
                    // Display Sun, Moon, and Ascendant signs
                    Text("☉ \(viewModel.sunSign) ☾ \(viewModel.moonSign) ↑ \(viewModel.ascendantSign)")
                        .font(.system(size: 12))
                        .foregroundColor(Color.gray)
                }
            }
            .padding([.leading, .bottom], 4)
            
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
                    Image(didLike ? "stardust_fill" : "stardust")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .padding(4)
                })
                
                NavigationLink(destination: CommentsView(post: post)) {
                    Image(systemName: "bubble.right")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .font(.system(size: 20))
                        .padding(4)
                        .foregroundColor(Color.theme.lavender)
                }
                
//                Button(action: {}, label: {
//                    Image(systemName: "paperplane")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 20, height: 20)
//                        .font(.system(size: 20))
//                        .padding(4)
//                        .foregroundColor(Color.theme.systemBackground)
//                })
            }
            .padding(.leading, 4)
            
            // likes display
            NavigationLink(value: SearchViewModelConfig.likes(viewModel.post.id ?? "")) {
                Text(viewModel.likeString)
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.leading, 8)
                    .padding(.bottom, 0.5)
                    .foregroundColor(Color.theme.lightLavender)
            }
            
            
            HStack {
                //Text(post.user?.username ?? "").font(.system(size: 14, weight: .semibold)) +
                    Text(" \(post.caption)")
                    .font(.system(size: 14))
            }.padding(.horizontal, 8)
            
            // post age
            Text(post.timestamp.timestampString())
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.leading, 8)
                .padding(.top, -2)
        }
        .padding(8)
        .background(Color.white)
        .cornerRadius(8) 
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
    }
}
