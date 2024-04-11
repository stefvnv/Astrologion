import SwiftUI

let planetOrder = ["Sun", "Moon", "Mercury", "Venus", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto", "North Node", "Lilith"]

struct PlanetsView: View {
    @ObservedObject var profileViewModel: ProfileViewModel

    var body: some View {
        ZStack {
            Image("profile-background")
                .resizable()
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if let chart = profileViewModel.userChart {
                    ForEach(planetOrder, id: \.self) { planet in
                        if let zodiacSign = chart.planetaryPositions[planet], let houseNumber = chart.planetaryHousePositions[planet] {
                            let housePosition = "\(houseNumber)H"

                            PlanetDetailView(planetName: planet, zodiacSign: zodiacSign, housePosition: housePosition)
                        }
                    }
                    .padding(.top, 10)
                } else {
                    Text("Loading planets or no chart available.")
                }
            }
        }
        .onAppear {
            profileViewModel.fetchUserChart()
        }
    }
}
