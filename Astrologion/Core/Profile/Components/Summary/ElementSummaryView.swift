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
        
        VStack {
            Text("Element")
                .font(.custom("PlayfairDisplay-Regular", size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color.theme.purple)
                .padding(.bottom)
            BarView(summaries: elementSummaries)
        }
        .padding()
        .padding(.bottom, 30)
    }
}
