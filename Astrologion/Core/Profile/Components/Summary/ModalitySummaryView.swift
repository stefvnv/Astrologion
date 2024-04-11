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
        
        VStack(alignment: .center) {
            Text("Modality")
                .font(.custom("PlayfairDisplay-Regular", size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color.theme.purple)
                .padding(.bottom)
            BarView(summaries: modalitySummaries)
        }
        .padding()
        .padding(.bottom, 30)
    }
}
