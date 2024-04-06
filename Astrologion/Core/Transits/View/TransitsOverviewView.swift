import SwiftUI

struct TransitsOverviewView: View {
    let user: User
    @ObservedObject var transitsViewModel: TransitsViewModel
    @State private var selectedPlanet: Planet?

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
                ForEach(Planet.allCases.filter { ![.Ascendant, .Midheaven, .Lilith, .NorthNode].contains($0) }, id: \.self) { planet in
                    if let matchingTransit = transitsViewModel.currentTransits.first(where: { $0.planet == planet }) {
                        TransitOverviewDetailView(planet: planet, sign: matchingTransit.sign, house: House(rawValue: matchingTransit.house) ?? .first)
                    } else {
                        TransitOverviewDetailView(planet: planet, sign: ZodiacSign.Aries, house: House.first)
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}
