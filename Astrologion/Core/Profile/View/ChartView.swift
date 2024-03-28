import SwiftUI

struct ChartView: View {
    let user: User
    @StateObject var profileViewModel: ProfileViewModel
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let chart = profileViewModel.userChart {
                    NatalChartViewRepresentable(chart: chart)
                        .frame(height: 600)
                }
            }
        }
    }
}


struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Test chart here")
        //ChartView(chart: Chart())
    }
}
