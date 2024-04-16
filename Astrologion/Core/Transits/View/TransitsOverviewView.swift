import SwiftUI

struct TransitsOverviewView: View {
    let user: User
    @ObservedObject var transitsViewModel: TransitsViewModel
    @Binding var selectedTab: TransitTab
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                if let chart = transitsViewModel.userChart {
                    TransitChartViewRepresentable(
                        user: user,
                        currentTransits: transitsViewModel.currentTransits,
                        transitsViewModel: transitsViewModel,
                        selectedPlanet: nil
                    )
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
                } else {
                    Text("Loading chart...")
                        .frame(height: 600)
                }
                
                Image("logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, -90)
            }
            .padding(.bottom, 100)
            
            if transitsViewModel.isLoadingChartData {
                ProgressView()
            } else {
                ForEach(Planet.allCases.filter { ![.Ascendant, .Midheaven, .Lilith, .NorthNode].contains($0) }, id: \.self) { planet in
                    if let matchingTransit = transitsViewModel.currentTransits.first(where: { $0.planet == planet }) {
                        TransitOverviewDetailView(planet: planet, sign: matchingTransit.sign, house: House(rawValue: matchingTransit.house) ?? .first) {
                            self.selectedTab = TransitTab(rawValue: planet.rawValue.lowercased()) ?? .overview
                        }
                    } else {
                        TransitOverviewDetailView(planet: planet, sign: ZodiacSign.Aries, house: House.first) {
                            self.selectedTab = TransitTab(rawValue: planet.rawValue.lowercased()) ?? .overview
                        }
                    }
                }
                .padding(.bottom, 20)
            }
        }
    }
}
