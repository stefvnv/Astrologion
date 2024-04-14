import SwiftUI

struct ChartView: View {
    let user: User
    @StateObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            Color.theme.lightLavender.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                if let chart = profileViewModel.userChart {
                    NatalChartViewRepresentable(chart: chart)
                        .aspectRatio(1, contentMode: .fit)
                } else {
                    Text("Natal chart for this user not available.")
                        .foregroundColor(Color.theme.darkBlue)
                }
                
                Spacer()
            }
        }
    }
}
