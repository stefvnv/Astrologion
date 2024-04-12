import SwiftUI

struct TransitsPlanetSummaryView: View {
    var transit: Transit
    var summaryDescription: String

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    Text(transit.planet.symbol ?? "")
                        .font(.system(size: 40))
                        .foregroundColor(Color(transit.planet.color))
                    Text(transit.planet.rawValue)
                        .font(.custom("Dosis", size: 14))
                        .foregroundColor(Color.theme.lightLavender)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
                // Zodiac sign symbol and name
                VStack {
                    Text(transit.sign.symbol)
                        .font(.system(size: 40))
                        .foregroundColor(transit.sign.element.color.color)
                    Text(transit.sign.rawValue)
                        .font(.custom("Dosis", size: 14))
                        .foregroundColor(Color.theme.lightLavender)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
                // House information
                VStack {
                    if let houseEnum = House(rawValue: transit.house) {
                        Text("\(houseEnum.shortHouseFormat)")
                            .font(.custom("Dosis", size: 24))
                            .foregroundColor(Color.theme.lavender)
                            .padding(.vertical, 6)
                        Text(houseEnum.keyword)
                            .font(.custom("Dosis", size: 14))
                            .foregroundColor(Color.theme.lightLavender)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }

            Text(summaryDescription)
                .font(.custom("Dosis", size: 16))
                .foregroundColor(Color.theme.lightLavender)
                .padding()
        }
        .padding()
        .background(Color(transit.planet.color).opacity(0.5))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }
}
