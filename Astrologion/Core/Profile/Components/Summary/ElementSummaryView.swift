import SwiftUI

struct ElementSummaryView: View {
    @ObservedObject var profileViewModel: ProfileViewModel

    var body: some View {
        let elementDistribution = profileViewModel.calculateElementPercentages()
        let elementSummaries = Element.allCases.map { element -> Summary in
            let percentage = elementDistribution[element] ?? 0
            return Summary(
                type: element.rawValue,
                symbol: element.symbol,
                percentage: percentage,
                color: element.color.color 
            )
        }
        
        VStack(alignment: .leading) {
            Text("Elements").font(.headline)
            BarView(summaries: elementSummaries)
        }
        .padding()
    }
}
