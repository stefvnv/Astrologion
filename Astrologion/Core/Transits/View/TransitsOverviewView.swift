import SwiftUI

struct TransitsOverviewView: View {
    let user: User
    @ObservedObject var transitsViewModel: TransitsViewModel

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
                let uniqueSortedTransits = getUniqueSortedTransits(transits: transitsViewModel.currentTransits)
                
                ForEach(uniqueSortedTransits, id: \.planet) { transit in
                    TransitDetailView(planet: transit.planet, sign: transit.sign, house: House(rawValue: transit.house) ?? .first)
                }
                .padding(.bottom, 20)
            }
        }
    }

    private func getUniqueSortedTransits(transits: [Transit]) -> [Transit] {
        let uniquePlanets = Set(transits.map { $0.planet })
        var uniqueTransits: [Transit] = []
        
        for planet in Planet.allCases {
            if let transit = transits.first(where: { $0.planet == planet }) {
                uniqueTransits.append(transit)
            }
        }
        
        return uniqueTransits.filter { transit in
            switch transit.planet {
            case .Sun, .Moon, .Mercury, .Venus, .Mars, .Jupiter, .Saturn, .Uranus, .Neptune, .Pluto:
                return true
            default:
                return false
            }
        }
    }
    
    private func ordinal(number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)th"
    }
}
