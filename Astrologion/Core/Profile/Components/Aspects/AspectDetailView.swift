import SwiftUI

struct AspectDetailView: View {
    var leadingPlanetName: String
    var trailingPlanetName: String
    var aspectType: Aspect
    var orb: Double
    @State private var showExpandedView = false

    var body: some View {
        Button(action: {
            showExpandedView = true
        }) {
            content
        }
        .sheet(isPresented: $showExpandedView) {
            AspectExpandedView(leadingPlanet: leadingPlanetName, trailingPlanet: trailingPlanetName, aspectType: aspectType)
        }
    }

    @ViewBuilder
    var content: some View {
        HStack {
            VStack { // planet1
                PlanetImage(name: leadingPlanetName)
                Text(leadingPlanetName)
                    .font(.custom("Dosis", size: 16))
                    .fontWeight(.regular)
                    .foregroundColor(Color.theme.darkBlue)
            }
            .padding(.vertical, 5)

            Spacer()
            
            VStack { // aspect, symbol, orb

                Text(aspectType.description)
                    .font(.custom("PlayfairDisplay-Regular", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(Color.theme.purple)
                Text(aspectType.symbol)
                    .font(.title3)
                    .foregroundColor(Color(uiColor: aspectType.darkerColor))
                Text(String(format: "%.2f° orb", orb))
                    .font(.custom("Dosis", size: 12))
                    .fontWeight(.regular)
                    .foregroundColor(Color.theme.darkBlue)
            }
            .padding(.vertical, 5)

            Spacer()
            
            VStack { // planet2
                PlanetImage(name: trailingPlanetName)
                Text(trailingPlanetName)
                    .font(.custom("Dosis", size: 16))
                    .fontWeight(.regular)
                    .foregroundColor(Color.theme.darkBlue)
            }
            .padding(.vertical, 5)
        }
        .background(Color(uiColor: aspectType.uiColor).opacity(0.35))
        .cornerRadius(10)
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct AspectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AspectDetailView(
            leadingPlanetName: "Sun",
            trailingPlanetName: "Moon",
            aspectType: .trine,
            orb: 0.5
        )
        .previewLayout(.sizeThatFits)
    }
}
