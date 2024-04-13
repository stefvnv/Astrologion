import SwiftUI
import Kingfisher

struct ConversationCell: View {
    let message: Message
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 12) {
                CircularProfileImageView(user: message.user, size: .small)
                
                VStack(alignment: .leading, spacing: 4) {
                    if let user = message.user {
                        Text(user.username)
                            .font(Font.custom("PlayfairDisplay-Regular", size: 17).weight(.semibold))
                            .foregroundColor(Color.theme.lightLavender)
                    }
                    
                    Text(message.text)
                        .font(Font.custom("Dosis", size: 16))
                        .foregroundColor(Color.theme.lightLavender)
                        .lineLimit(2)
                }
                .foregroundColor(.black)
                .padding(.trailing)
                
                Spacer()
            }
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.theme.lavender)
        }
        
    }
}
