import SwiftUI

struct TransitOverviewDetailView: View {
    var planet: Planet
    var sign: ZodiacSign
    var house: House

    var body: some View { // TODO: Make clickable and bring to relavant tab based on planet
        HStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .padding(.trailing, 20)

            Text("\(planet.descriptionPrefix) is in \(sign.rawValue) in your \(house.formattedName.lowercased()) of \(house.keyword.lowercased()).")
                .foregroundColor(.black)

            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 5)
    }

    private var imageName: String {
        switch planet {
        case .NorthNode: return "northnode"
        default: return planet.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
        }
    }
}
