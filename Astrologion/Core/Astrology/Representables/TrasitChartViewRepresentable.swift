import SwiftUI

struct TransitChartViewRepresentable: UIViewRepresentable {
    var user: User
    var currentTransits: [Transit]
    var transitsViewModel: TransitsViewModel
    var selectedPlanet: Planet?

    func makeUIView(context: Context) -> TransitChartView {
        let transitChartView = TransitChartView()
        transitChartView.transitsViewModel = transitsViewModel
        transitChartView.selectedPlanet = selectedPlanet
        return transitChartView
    }

    func updateUIView(_ uiView: TransitChartView, context: Context) {
        uiView.transitsViewModel = transitsViewModel
        uiView.selectedPlanet = selectedPlanet
        uiView.setNeedsDisplay()
    }
}
