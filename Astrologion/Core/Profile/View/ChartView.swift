import SwiftUI

struct ChartView: View {
    let user: User
    @StateObject var profileViewModel: ProfileViewModel
    
    var body: some View {
        ZStack {
            Image("profile-background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if let chart = profileViewModel.userChart {
                    NatalChartViewRepresentable(chart: chart)
                }
            }
        }
    }
}
