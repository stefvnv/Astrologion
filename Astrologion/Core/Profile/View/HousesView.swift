import SwiftUI

struct HousesView: View {
    @ObservedObject var profileViewModel: ProfileViewModel

    var body: some View {
        ZStack {
            Color.theme.lightLavender.edgesIgnoringSafeArea(.all)
            
            VStack {
                if let chart = profileViewModel.userChart {
                    ForEach(House.allCases, id: \.self) { house in
                        if let signWithDegree = chart.houseCusps["House \(house.rawValue)"] {
                            HouseDetailView(house: house, signWithDegree: signWithDegree)
                        }
                    }
                    .padding(.top, 10)
                } else {
                    Text("Loading houses or no chart available.")
                }
            }
        }
        .onAppear {
            profileViewModel.fetchUserChart()
        }
    }
}

struct HousesView_Previews: PreviewProvider {
    static var previews: some View {
        HousesView(profileViewModel: ProfileViewModel(user: dev.user))
    }
}
