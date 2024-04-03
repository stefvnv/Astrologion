import SwiftUI

struct TransitsOverviewView: View {
    let user: User
    @ObservedObject var transitsViewModel: TransitsViewModel

    var body: some View {
        VStack {
            if let chart = transitsViewModel.userChart {
                NatalChartViewRepresentable(chart: chart)
                    .frame(height: 600)
            } else {
                Text("Loading chart...")
                    .frame(height: 600)
            }

            Divider()
                .overlay(Image("logo").resizable().aspectRatio(contentMode: .fit).frame(width: 60, height: 60), alignment: .center)

            if transitsViewModel.isLoadingChartData {
                ProgressView()
            } else {
                Text("Transits count: \(transitsViewModel.currentTransits.count)")
                ForEach(transitsViewModel.currentTransits) { transit in
                    Text("The \(transit.planet.rawValue) is in \(transit.sign.rawValue), in your \(ordinal(number: transit.house)) house - \(transit.aspect.rawValue) aspect.")
                        .padding()
                }
            }
        }
    }

    private func ordinal(number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .ordinal
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)th"
    }
}
