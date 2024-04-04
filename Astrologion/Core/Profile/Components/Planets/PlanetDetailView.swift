import SwiftUI

struct PlanetDetailView: View {
    var planetName: String
    var zodiacSign: String
    var housePosition: String
    @State private var showExpandedView = false

    var body: some View {
        Button(action: {
            showExpandedView = true
        }) {
            content
        }
        .sheet(isPresented: $showExpandedView) {
            let components = zodiacSign.split(separator: " ")
            if let zodiacEnum = ZodiacSign(rawValue: String(components[0])),
               let planetEnum = Planet(rawValue: planetName) {
                PlanetExpandedView(planet: planetEnum, zodiacSign: zodiacEnum)
            } else {
                Text("Invalid Planet or Zodiac Sign")
            }
        }
    }
    
    @ViewBuilder
    var content: some View {
        ZStack(alignment: .leading) {
            HStack {
                Spacer().frame(width: 25)
                
                VStack(alignment: .leading) {
                    Text(planetName)
                        .font(.headline)
                    Text(zodiacSign)
                        .font(.subheadline)
                }
                
                Spacer()
                
                Text(housePosition)
                    .font(.headline)
                    .frame(minWidth: 44) 
                    .padding(.trailing, 20)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .overlay(
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .offset(x: -30),
                alignment: .leading
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, 30)
        .padding(.horizontal)
        .padding(.vertical, 10)
    }

    private var imageName: String {
        switch planetName {
        case "North Node": return "northnode"
        default: return planetName.lowercased().replacingOccurrences(of: " ", with: "")
        }
    }
}

struct PlanetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetDetailView(planetName: "North Node", zodiacSign: "Leo", housePosition: "5H")
            .previewLayout(.sizeThatFits)
    }
}
