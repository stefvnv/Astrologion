import SwiftUI

struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                CircularProfileImageView(user: viewModel.user, size: .large)
                    .padding(.leading)
                
                VStack(alignment: .leading) {
                    Text("\(viewModel.user.fullname ?? "No Name") (@\(viewModel.user.username))")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if viewModel.isLoadingChartData {
                        Text("Loading astrological details...")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        HStack {
                            Text("☉ \(viewModel.sunSign)")
                            Text("☾ \(viewModel.moonSign)")
                            Text("↑ \(viewModel.ascendantSign)")
                        }
                        .font(.subheadline)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            ProfileActionButtonView(viewModel: viewModel)
                .padding(.top)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(viewModel: ProfileViewModel(user: dev.user))
    }
}
