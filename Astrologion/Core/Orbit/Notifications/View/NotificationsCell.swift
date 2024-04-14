import SwiftUI
import Kingfisher

struct NotificationCell: View {
    @ObservedObject var viewModel: NotificationCellViewModel
    @Binding var notification: Notification
    
    var isFollowed: Bool {
        return notification.isFollowed ?? false
    }
    
    init(notification: Binding<Notification>) {
        self.viewModel = NotificationCellViewModel(notification: notification.wrappedValue)
        self._notification = notification
    }
    
    var body: some View {
        HStack {
            if let user = notification.user {
                NavigationLink(destination: ProfileView(user: user)) {
                    CircularProfileImageView(user: user, size: .xSmall)
                    
                        HStack {
                            
                            Text(user.username)
                                .font(.custom("Dosis", size: 15).weight(.semibold))
                                .foregroundColor(Color.theme.lavender)
                            
                            Text(notification.type.notificationMessage)
                                .font(.custom("Dosis", size: 14))
                                .foregroundColor(Color.theme.lightLavender)

                            Text(notification.timestamp.timestampString())
                                .font(.custom("Dosis", size: 12))
                                .foregroundColor(.gray)
                        }
                }
            }
            
            Spacer()
            
            if notification.type != .follow {
                if let post = notification.post {
                    NavigationLink(destination: FeedCell(post: post)) {
                        KFImage(URL(string: post.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipped()
                    }
                }
            } else {
                Button(action: {
                    isFollowed ? viewModel.unfollow() : viewModel.follow()
                    notification.isFollowed?.toggle()
                }, label: {
                    Image(isFollowed ? "follow-fill" : "follow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                })
                .frame(width: 100, height: 32)
                .background(isFollowed ? Color.theme.yellow: Color.theme.lightLavender)
                .cornerRadius(6)
            }
        }
        .padding(.horizontal)
    }
}
