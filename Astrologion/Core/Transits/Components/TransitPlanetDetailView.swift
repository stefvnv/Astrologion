import SwiftUI

struct TransitsPlanetDetailView: View {
    @ObservedObject var transitsViewModel: TransitsViewModel
    var transit: Transit

    var body: some View {
        ScrollView { // Encapsulate in ScrollView for multiple items
            VStack {
                ForEach(Array(transit.aspects.enumerated()), id: \.offset) { _, aspect in
                    VStack {
                        Text("\(transit.planet.rawValue) \(aspect.rawValue) \(transit.natalPlanet.rawValue)")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding(.top, 5)

                        Text(aspect.symbol)
                            .font(.largeTitle)
                            .padding(.vertical, 2)

                        if let descriptionData = transitsViewModel.transitDescription.first(where: {
                            $0.transit.compare(transit.descriptionKey(for: aspect), options: .caseInsensitive) == .orderedSame
                        }) {
                            Text(descriptionData.title)
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.bottom, 2)

                            Text(descriptionData.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 5)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity) // Ensure it takes up full width
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal) // Adjust horizontal padding if needed
                    .padding(.vertical, 5) // Add vertical padding for spacing between items
                }
            }
        }
    }
}
