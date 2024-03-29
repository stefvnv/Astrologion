import SwiftUI

struct ChartView: View {
    let user: User
    @StateObject var profileViewModel: ProfileViewModel
    
    
    var body: some View {
        
        VStack(spacing: 24) {
            if let chart = profileViewModel.userChart {
                NatalChartViewRepresentable(chart: chart)
                    .frame(height: 600)
            }
        }
    }
}
