import SwiftUI

struct TransitsPlanetSummaryView: View {
    var transit: Transit
    var summaryDescription: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(transit.sign.symbol)
                    .font(.title3)
                Text(transit.planet.rawValue.uppercased())
                    .font(.title3)
                    .fontWeight(.bold)
                if let houseEnum = House(rawValue: transit.house) {
                    Text("\(houseEnum.shortHouseFormat)")
                        .font(.title3)
                        .fontWeight(.bold)
                } else {
                    Text("Invalid House")
                }
            }
            .padding()

            Text(summaryDescription)
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding()
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
