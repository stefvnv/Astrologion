import SwiftUI

struct ProfileActionButtonView: View {
    @ObservedObject var viewModel: ProfileViewModel
    var isFollowed: Bool { return viewModel.user.isFollowed ?? false }
    @State var showEditProfile = false
    
    var body: some View {
        VStack {
            if viewModel.user.isCurrentUser {
                Button(action: { showEditProfile.toggle() }) {
                    Image("edit")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .foregroundColor(Color.theme.lavender)
                }
                .frame(width: 32, height: 32)
                .contentShape(Rectangle())
                .fullScreenCover(isPresented: $showEditProfile) {
                    EditProfileView(user: $viewModel.user)
                }
            } else {
                Button(action: {
                    isFollowed ? viewModel.unfollow() : viewModel.follow()
                    viewModel.user.isFollowed?.toggle()
                }) {
                    Image(isFollowed ? "follow-fill" : "follow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .frame(width: 32, height: 32)
                .background(isFollowed ? Color.theme.yellow : Color.theme.lightLavender)
                .cornerRadius(6)
                .buttonStyle(PlainButtonStyle())
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.clear, lineWidth: 0)
                )
            }
            
            Divider()
                .padding(.top, 4)
        }
    }
}

struct ProfileActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileActionButtonView(viewModel: ProfileViewModel(user: dev.user))
    }
}
