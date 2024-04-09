import SwiftUI

struct TransitsPlanetDetailView: View {
    @ObservedObject var transitsViewModel: TransitsViewModel
    var transit: Transit

    var body: some View {
        ScrollView {
            VStack {
                ForEach(Array(transit.aspects.enumerated()), id: \.offset) { index, aspect in
                    VStack {
                        Text("\(transit.planet.rawValue) \(aspect.relationship) \(transit.natalPlanet?.rawValue ?? "Transit")")
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
                        } else {
                            Text("No description available.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .padding(.bottom, 5)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
                }
            }
        }
    }
}
