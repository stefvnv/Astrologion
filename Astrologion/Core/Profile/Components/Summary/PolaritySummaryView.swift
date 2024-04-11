import SwiftUI

struct PolaritySummaryView: View {
    @ObservedObject var profileViewModel: ProfileViewModel

    var body: some View {
        let polarityDistribution = profileViewModel.calculatePolarityPercentages()
        let polaritySummaries = Polarity.allCases.map { polarity -> Summary in
            let percentage = polarityDistribution[polarity] ?? 0
            return Summary(
                type: polarity.rawValue,
                symbol: polarity.symbol,
                percentage: percentage,
                color: Color(polarity.color)
            )
        }

        VStack(alignment: .center) {
            Text("Polarity")
                .font(.custom("PlayfairDisplay-Regular", size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color.theme.purple)
                .padding(.bottom)
            BarView(summaries: polaritySummaries)
        }
        .padding()
        .padding(.bottom, 30)
    }
}
