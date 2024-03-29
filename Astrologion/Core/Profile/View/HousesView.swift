import SwiftUI

struct HousesView: View {
    @ObservedObject var profileViewModel: ProfileViewModel

    var body: some View {
        VStack {
            if let chart = profileViewModel.userChart {
                ForEach(House.allCases, id: \.self) { house in
                    if let signWithDegree = chart.houseCusps["House \(house.rawValue)"] {
                        HouseDetailView(house: house, signWithDegree: signWithDegree)
                    }
                }
            } else {
                Text("Loading houses or no chart available")
            }
        }
    }
}

struct HousesView_Previews: PreviewProvider {
    static var previews: some View {
        HousesView(profileViewModel: ProfileViewModel(user: dev.user))
    }
}
