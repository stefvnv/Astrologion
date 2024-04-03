import SwiftUI

struct NatalChartViewRepresentable: UIViewRepresentable {
    var chart: Chart

    
    /// Initializes view model with chart
    func makeUIView(context: Context) -> NatalChartView {
        let natalChartView = NatalChartView()
        let viewModel = NatalChartViewModel(chart: chart)
        natalChartView.viewModel = viewModel
        return natalChartView
    }

    
    /// Updates chart in the view model
    func updateUIView(_ uiView: NatalChartView, context: Context) {
        uiView.viewModel?.chart = chart
        uiView.setNeedsDisplay()
    }
}
