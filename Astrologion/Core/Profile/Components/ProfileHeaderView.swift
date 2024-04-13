import SwiftUI

struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            
            // semi circle and profile picture
            ZStack {
                
                // semi-circle
                Path { path in
                    let width = UIScreen.main.bounds.width
                    let radius = width / 2 + 50
                    let yOffset = -radius / 2
                    let arcCenter = CGPoint(x: width / 2, y: yOffset)
                    
                    path.addArc(center: arcCenter,
                                radius: radius,
                                startAngle: .degrees(180),
                                endAngle: .degrees(0),
                                clockwise: true)
                }
                .fill(Color.theme.darkBlue)
                .frame(height: UIScreen.main.bounds.width / 2)
                
                // profile picture
                CircularProfileImageView(user: viewModel.user, size: .large)
                    .frame(width: 250, height: 250)
                    .offset(y: UIScreen.main.bounds.width / 4 - 90)
            }
            
            // profile info
            VStack(alignment: .center, spacing: 8) {
                Text("@\(viewModel.user.username)")
                    .font(.custom("PlayfairDisplay-Regular", size: 22))
                    .fontWeight(.semibold)
                    .padding([.top])

                if let fullname = viewModel.user.fullname, !fullname.isEmpty {
                    Text(fullname)
                        .font(.custom("Dosis", size: 18))
                        .fontWeight(.semibold)
                }
                
                if let bio = viewModel.user.bio, !bio.isEmpty {
                    Text(bio)
                        .font(.custom("Dosis", size: 16))
                }
                
                // big three
                if viewModel.isLoadingChartData {
                    Text("Loading astrological details...")
                        .font(.custom("Dosis", size: 16))
                        .foregroundColor(.gray)
                } else {
                    HStack {
                        Text("☉ \(viewModel.sunSign)")
                        Text("☾ \(viewModel.moonSign)")
                        Text("↑ \(viewModel.ascendantSign)")
                    }
                    .font(.custom("Dosis", size: 16))
                }
            }
            .padding(.top, -80)
        }
        .background(Color.theme.lightLavender)
        .edgesIgnoringSafeArea(.all)
    }
}


struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(viewModel: ProfileViewModel(user: dev.user))
    }
}
