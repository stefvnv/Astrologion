import SwiftUI

struct TransitChartViewRepresentable: UIViewRepresentable {
    var user: User
    var transitsViewModel: TransitsViewModel

    func makeUIView(context: Context) -> TransitChartView {
        let transitChartView = TransitChartView()
        transitChartView.transitsViewModel = transitsViewModel
        
        return transitChartView
    }

    func updateUIView(_ uiView: TransitChartView, context: Context) {
        uiView.setNeedsDisplay()
    }
}
