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
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                CircularProfileImageView(user: viewModel.post.user, size: .xSmall)
                
                VStack(alignment: .leading, spacing: 0) {
                    NavigationLink(value: viewModel.post.user) {
                        Text(viewModel.post.user?.username ?? "")
                            .font(Font.custom("Dosis", size: 14).weight(.semibold))
                            .foregroundColor(Color.theme.lightLavender)
                    }
                    
                    HStack {
                        Text("☉ \(viewModel.sunSign)  ☾ \(viewModel.moonSign)  ↑ \(viewModel.ascendantSign)")
                            .font(Font.custom("Dosis", size: 12))
                            .foregroundColor(Color.gray)
                        
                        Spacer()
                        
                        Text(post.timestamp.timestampString())
                            .font(.custom("Dosis", size: 12))
                            .foregroundColor(.gray)
                            .padding(.trailing)
                    }
                }
            }
            .padding(.leading, 8)
            .padding(.bottom, 10)
 
            HStack {
                
                KFImage(URL(string: post.imageUrl))
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 400)
                    .clipped()
                    .contentShape(Rectangle())
            }
            .padding(.bottom, 5)
            
            
            HStack(spacing: -8) {
                Button(action: {
                    Task {
                        if viewModel.post.didLike ?? false {
                            try await viewModel.unlike()
                        } else {
                            try await viewModel.like()
                        }
                    }
                }) {
                    Text("\(viewModel.likeString)")
                        .font(.custom("Dosis", size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(didLike ? Color.yellow.opacity(0.5) : Color.theme.lavender.opacity(0.5))
                        .cornerRadius(8)
                }
                .padding(8)
                
                Spacer()
                
                NavigationLink(destination: CommentsView(post: post)) {
                    Text("Comments")
                        .font(.custom("Dosis", size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(Color.theme.lavender.opacity(0.5))
                        .cornerRadius(8)
                }
                .padding(8)
            }
            .frame(maxWidth: .infinity)
            
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.caption)
                        .font(.custom("Dosis", size: 14))
                        .foregroundColor(Color.theme.lightLavender)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
        }
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.9), radius: 2, x: 0, y: 2)
        .background(Color.theme.darkBlue.edgesIgnoringSafeArea(.all))

    }
}
