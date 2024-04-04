import SwiftUI

struct TransitChartViewRepresentable: UIViewRepresentable {
    var user: User
    var currentTransits: [Transit]
    var transitsViewModel: TransitsViewModel

    func makeUIView(context: Context) -> TransitChartView {
        let transitChartView = TransitChartView()
        transitChartView.transitsViewModel = transitsViewModel
        
        return transitChartView
    }

    func updateUIView(_ uiView: TransitChartView, context: Context) {
        uiView.transitsViewModel = transitsViewModel
        uiView.setNeedsDisplay()
    }

}
