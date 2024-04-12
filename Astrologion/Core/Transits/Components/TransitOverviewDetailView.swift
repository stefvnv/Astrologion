import SwiftUI

struct TransitOverviewDetailView: View {
    var planet: Planet
    var sign: ZodiacSign
    var house: House
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .padding(.trailing, 20)
                
                // planet symbol and name
                VStack {
                    Text(planet.symbol ?? "")
                        .font(.system(size: 40))
                        .foregroundColor(Color(planet.color))
                    Text(planet.rawValue)
                        .font(.custom("Dosis", size: 14))
                        .foregroundColor(Color.theme.lightLavender)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
                // zodiac sign symbol and name
                VStack {
                    Text(sign.symbol)
                        .font(.system(size: 40))
                        .foregroundColor(sign.element.color.color)
                    Text(sign.rawValue)
                        .font(.custom("Dosis", size: 14))
                        .foregroundColor(Color.theme.lightLavender)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
                // house information
                VStack {
                    Text(house.shortHouseFormat)
                        .font(.custom("Dosis", size: 24))
                        .foregroundColor(Color.theme.lavender)
                        .padding(.vertical, 6)
                    Text(house.keyword)
                        .font(.custom("Dosis", size: 14))
                        .foregroundColor(Color.theme.lightLavender)
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding()
            .background(Color(planet.color).opacity(0.5))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
    }

    private var imageName: String {
        switch planet {
        case .NorthNode: return "northnode"
        default: return planet.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
        }
    }
}
