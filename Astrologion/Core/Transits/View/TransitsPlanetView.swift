import SwiftUI

struct TransitsPlanetView: View {
    let user: User
    @ObservedObject var transitsViewModel: TransitsViewModel
    let selectedPlanet: Planet
    
    var body: some View {
        VStack {
            transitChartSection
            
            transitSummaryView()
            
            transitsDetailSection
        }
        .navigationTitle("\(selectedPlanet.rawValue) Transits")
    }
    
    private var transitChartSection: some View {
        ZStack(alignment: .bottom) {
            TransitChartViewRepresentable(
                user: user,
                currentTransits: transitsViewModel.currentTransits,
                transitsViewModel: transitsViewModel,
                selectedPlanet: selectedPlanet
            )
            .aspectRatio(1, contentMode: .fit)
            .padding()

            Image(self.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .padding(.bottom, -80)
        }
        .padding(.bottom, 80)
    }
    
    private func transitSummaryView() -> some View {
        guard let transit = transitsViewModel.currentTransits.first(where: { $0.planet == selectedPlanet }) else {
            return AnyView(Text("No transiting data for \(selectedPlanet.rawValue)").padding())
        }
        
        let summaryDescription = transit.transitSummaryDescription(
            descriptions: transitsViewModel.transitSummaryDescriptions
        )
        
        return AnyView(TransitsPlanetSummaryView(transit: transit, summaryDescription: summaryDescription))
    }
    
    
    private var transitsDetailSection: some View {
        ForEach(transitsViewModel.currentTransits.filter { $0.planet == selectedPlanet }, id: \.id) { transit in
            TransitsPlanetDetailView(transitsViewModel: transitsViewModel, transit: transit)
        }
        .padding(.bottom, 20)
    }
    
    private var imageName: String {
        switch selectedPlanet {
        case .NorthNode: return "northnode"
        default: return selectedPlanet.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
        }
    }
}
