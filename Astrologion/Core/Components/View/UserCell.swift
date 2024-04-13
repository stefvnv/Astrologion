import SwiftUI
import Kingfisher

struct UserCell: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 12) {
            CircularProfileImageView(user: user, size: .small)
            
            VStack(alignment: .leading) {
                Text(user.username)
                    .font(Font.custom("PlayfairDisplay-Regular", size: 14).weight(.semibold))
                    .foregroundColor(Color.theme.lightLavender)
                
            }
            .foregroundColor(Color.theme.darkBlue)
            
            Spacer()
        }
    }
}
