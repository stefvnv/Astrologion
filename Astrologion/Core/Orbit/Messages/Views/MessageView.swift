import SwiftUI
import Kingfisher

struct MessageView: View {
    let viewModel: MessageViewModel
    
    var body: some View {
        HStack {
            if viewModel.isFromCurrentUser {
                Spacer()
                Text(viewModel.message.text)
                    .font(Font.custom("Dosis", size: 16))
                    .padding(10)
                    .background(Color.theme.yellow)
                    .clipShape(ChatBubble(isFromCurrentUser: true))
                    .foregroundColor(Color.theme.darkBlue)
                    .padding(.leading, 100)
                    .padding(.trailing)
            } else {
                HStack(alignment: .bottom) {
                    CircularProfileImageView(user: viewModel.message.user, size: .xSmall)
                    
                    Text(viewModel.message.text)
                        .font(Font.custom("Dosis", size: 16))
                        .padding(10)
                        .background(Color.theme.lightLavender)
                        .clipShape(ChatBubble(isFromCurrentUser: false))
                        .foregroundColor(Color.theme.darkBlue)
                }
                .padding(.trailing, 100)
                .padding(.leading)
                
                Spacer()
            }
        }
    }
}
