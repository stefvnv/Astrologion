import SwiftUI
import Kingfisher

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
                    } else if let chart = viewModel.chart {
                        HStack {
                            Text("☉ \(chart.sunSign)") 
                            Text("☾ \(chart.moonSign)")
                            if let ascendantSign = chart.houseCusps["House 1"] {
                                Text("↑ \(ascendantSign)")
                            } else {
                                Text("↑ Unknown")
                            }
                        }
                        .font(.subheadline)
                    } else if let errorMessage = viewModel.chartDataErrorMessage {
                        Text(errorMessage)
                            .font(.subheadline)
                            .foregroundColor(.red)
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
