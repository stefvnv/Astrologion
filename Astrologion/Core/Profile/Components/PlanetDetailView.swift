import SwiftUI

struct PlanetDetailView: View {
    var planetName: String
    var zodiacSign: String

    private var imageName: String {
        switch planetName {
        case "North Node": return "northnode"
        default: return planetName.lowercased().replacingOccurrences(of: " ", with: "")
        }
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            HStack {
                Spacer().frame(width: 25) // make space for image to overlap
                
                VStack(alignment: .leading) {
                    Text(planetName)
                        .font(.headline)
                    Text(zodiacSign)
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .overlay(
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .offset(x: -30), // move image to left by half of its width
                alignment: .leading
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.leading, 30) // + of offset to ensure alignment
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct PlanetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PlanetDetailView(planetName: "North Node", zodiacSign: "Leo")
            .previewLayout(.sizeThatFits)
    }
}
