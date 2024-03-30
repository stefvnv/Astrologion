import SwiftUI

struct ModalitySummaryView: View {
    @ObservedObject var profileViewModel: ProfileViewModel

    var body: some View {
        let modalityDistribution = profileViewModel.calculateModalityPercentages()
        let modalitySummaries = Modality.allCases.map { modality -> Summary in
            let percentage = modalityDistribution[modality] ?? 0
            return Summary(
                type: modality.rawValue,
                symbol: modality.symbol,
                percentage: percentage,
                color: Color(modality.color)
            )
        }
        
        VStack(alignment: .leading) {
            Text("Modality").font(.headline)
            BarView(summaries: modalitySummaries)
        }
        .padding()
    }
}
