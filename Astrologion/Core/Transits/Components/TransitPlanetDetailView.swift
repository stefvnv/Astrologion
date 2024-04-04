import SwiftUI

struct TransitsPlanetDetailView: View {
    @ObservedObject var transitsViewModel: TransitsViewModel
    var transit: Transit

    var body: some View {
        HStack {
            VStack {
                VStack(alignment: .center, spacing: 8) {
                    Text("\(transit.planet.rawValue) \(transit.aspect.rawValue) \(transit.natalPlanet.rawValue)")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.top, 5)
                    
                    Text(transit.aspect.symbol)
                        .font(.largeTitle)
                        .padding(.vertical, 2)
                    
                    if let descriptionData = transitsViewModel.transitDescription.first(where: {
                        $0.transit.compare(transit.descriptionKey(), options: .caseInsensitive) == .orderedSame
                    }) {
                        Text(descriptionData.title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .padding(.bottom, 2)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(transit.description(from: transitsViewModel.transitDescription))
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
