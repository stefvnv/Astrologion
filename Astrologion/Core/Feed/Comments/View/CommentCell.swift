import SwiftUI
import Kingfisher

struct CommentCell: View {
    let comment: Comment
    
    var body: some View {
        HStack {
            CircularProfileImageView(user: comment.user, size: .xxSmall)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 2) {
                    Text(comment.user?.username ?? "")
                        .fontWeight(.semibold)
                        .font(.custom("Dosis", size: 16))
                        .foregroundColor(Color.theme.lightLavender)
                    
                    Spacer()
                    
                    Text(comment.timestamp.timestampString())
                        .font(.custom("Dosis", size: 12))
                        .foregroundColor(.gray)
                }
                
                Text(comment.commentText)
                    .font(.custom("Dosis", size: 14))
                    .foregroundColor(Color.theme.lightLavender)
            }
        }
        .padding(.horizontal)
    }
}
