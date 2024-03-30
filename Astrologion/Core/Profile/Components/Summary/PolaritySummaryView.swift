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

        VStack(alignment: .leading) {
            Text("Polarity").font(.headline)
            BarView(summaries: polaritySummaries)
        }
        .padding()
    }
}
