import SwiftUI

struct TransitsOverviewView: View {
    let user: User
    @ObservedObject var transitsViewModel: TransitsViewModel

    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                if transitsViewModel.userChart != nil {
                    TransitChartViewRepresentable(user: user, currentTransits: transitsViewModel.currentTransits, transitsViewModel: transitsViewModel)
                        .frame(height: 600)
                } else {
                    Text("Loading chart...")
                        .frame(height: 600)
                }

                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, -50)
            }
            .padding(.bottom, 60)

            if transitsViewModel.isLoadingChartData {
                ProgressView()
            } else {
                // Iterate over a fixed list of planets, ensuring all are displayed in order
                ForEach(Planet.allCases.filter { ![Planet.Ascendant, .Midheaven, .Lilith, .NorthNode].contains($0) }, id: \.self) { planet in
                    // Find the corresponding transit or provide a default value
                    if let matchingTransit = transitsViewModel.currentTransits.first(where: { $0.planet == planet }) {
                        TransitOverviewDetailView(
                            planet: planet,
                            sign: matchingTransit.sign,
                            house: House(rawValue: matchingTransit.house) ?? .first
                        )
                    } else {
                        // Provide default values if no matching transit is found
                        TransitOverviewDetailView(
                            planet: planet,
                            sign: ZodiacSign.Aries, // Placeholder sign
                            house: House.first // Placeholder house
                        )
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}
