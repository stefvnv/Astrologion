import SwiftUI

struct NatalChartViewRepresentable: UIViewRepresentable {
    var viewModel: NatalChartViewModel

    func makeUIView(context: Context) -> NatalChartView {
        let natalChartView = NatalChartView()
        natalChartView.viewModel = viewModel
        return natalChartView
    }

    func updateUIView(_ uiView: NatalChartView, context: Context) {
        if uiView.viewModel !== viewModel {
            uiView.viewModel = viewModel
            uiView.updateChart()
        }
    }
}