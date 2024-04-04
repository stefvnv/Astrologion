import SwiftUI
import Kingfisher

struct UserCell: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 12) {
            CircularProfileImageView(user: user, size: .small)
            
            VStack(alignment: .leading) {
                Text(user.username)
                    .font(.system(size: 14, weight: .semibold))
                
                if let fullname = user.fullname {
                    Text(fullname)
                        .font(.system(size: 14))
                }
            }
            .foregroundColor(Color.theme.darkBlue)
            
            Spacer()
        }
    }
}
