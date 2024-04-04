import SwiftUI

struct TransitsPlanetView: View {
    let user: User
    @ObservedObject var transitsViewModel: TransitsViewModel
    let selectedPlanet: Planet
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                if let chart = transitsViewModel.userChart {
                    NatalChartViewRepresentable(chart: chart)
                        .frame(height: 600)
                } else {
                    Text("Loading chart...")
                        .frame(height: 600)
                }
                Image(self.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .padding(.bottom, -50)
            }
            .padding(.bottom, 60)
            
            if let transit = transitsViewModel.currentTransits.first(where: { $0.planet == selectedPlanet }) {
                HStack {
                    Text(transit.sign.symbol)
                        .font(.title3)
                    Text(selectedPlanet.rawValue.uppercased())
                        .font(.title3)
                        .fontWeight(.bold)
                    if let houseEnum = House(rawValue: transit.house) {
                        Text("\(houseEnum.shortHouseFormat)")
                            .font(.title3)
                            .fontWeight(.bold)
                    } else {
                        Text("Invalid House")
                    }
                }
                .padding()
            } else {
                Text("No transiting data for \(selectedPlanet.rawValue)").padding()
            }
            
            DividerWithTitle(title: "Transits")
            
            ForEach(transitsViewModel.currentTransits.filter { $0.planet == selectedPlanet }, id: \.id) { transit in
                TransitsPlanetDetailView(transitsViewModel: transitsViewModel, transit: transit)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("\(selectedPlanet.rawValue) Transits")
    }
    
    private var imageName: String {
        switch selectedPlanet {
        case .NorthNode: return "northnode"
        default: return selectedPlanet.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
        }
    }
}

struct DividerWithTitle: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.horizontal)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                    .offset(y: 8),
                alignment: .bottom
            )
    }
}
