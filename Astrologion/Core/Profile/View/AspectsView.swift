import SwiftUI

struct AspectsView: View {
    @ObservedObject var profileViewModel: ProfileViewModel

    var body: some View {
        ZStack {
            Color.theme.lightLavender.edgesIgnoringSafeArea(.all)

            VStack {
                if let chart = profileViewModel.userChart {
                    let aspectsData = profileViewModel.parseAspects(from: chart)
                    ForEach(aspectsData, id: \.self) { aspectData in
                        AspectDetailView(
                            leadingPlanetName: aspectData.planet1.rawValue,
                            trailingPlanetName: aspectData.planet2.rawValue,
                            aspectType: aspectData.aspect,
                            orb: aspectData.orb
                        )
                    }
                    .padding(.top, 10)
                } else {
                    Text("Loading aspects...")
                }
            }
        }
        .onAppear {
            profileViewModel.fetchUserChart()
        }
    }
}
