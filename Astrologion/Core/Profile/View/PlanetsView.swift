import SwiftUI

let planetOrder = ["Sun", "Moon", "Mercury", "Venus", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto", "North Node", "Lilith"]

struct PlanetsView: View {
    @ObservedObject var profileViewModel: ProfileViewModel

    var body: some View {
        VStack {
            if let chart = profileViewModel.userChart {
                ForEach(planetOrder, id: \.self) { planet in
                    
                    // check if planet is in chart
                    if let zodiacSign = chart.planetaryPositions[planet] {
                        PlanetDetailView(planetName: planet, zodiacSign: zodiacSign)
                    }
                }
            } else {
                Text("Loading planets or no chart available")
            }
        }
    }
}
