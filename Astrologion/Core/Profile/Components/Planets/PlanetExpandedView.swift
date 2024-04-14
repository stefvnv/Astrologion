import SwiftUI

struct PlanetExpandedView: View {
    let planet: Planet
    let zodiacSign: ZodiacSign
    let house: House
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack {
                GeometryReader { geo in
                    ZStack(alignment: .topLeading) {
                        Image(zodiacSign.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()

                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.5))
                                .clipShape(Circle())
                                .padding(16)
                        }
                    }
                }
                .frame(height: 300)

                Text("\(planet.rawValue) in \(zodiacSign.rawValue)")
                    .font(Font.custom("PlayfairDisplay-Regular", size: 26))
                    .foregroundColor(Color.theme.purple)
                    .padding()
                
                
                Text(house.shortHouseFormat)
                    .font(.custom("PlayfairDisplay-Regular", size: 18))
                    .foregroundColor(Color.theme.darkBlue)
                    .padding(10)
                    .background(
                        Circle()
                            .foregroundColor(Color.theme.darkBlue.opacity(0.2))
                    )

                HStack(spacing: 16) {
                    VStack {
                        zodiacSign.element.symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)
                    }
                    VStack {
                        zodiacSign.modality.symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)
                    }
                    VStack {
                        zodiacSign.polarity.symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 26, height: 26)
                    }
                }
                .font(.custom("Dosis", size: 20))
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 26)
                        .foregroundColor(zodiacSign.element.color.color)
                )
                .padding(.vertical, 20)

                // sign description
                Text(zodiacSign.signDescription(for: planet))
                    .font(.custom("Dosis", size: 18))
                    .foregroundColor(Color.theme.darkBlue)
                    .padding(20)

                // house description
                Text(house.description(for: planet, house: house))
                    .font(.custom("Dosis", size: 18))
                    .foregroundColor(Color.theme.darkBlue)
                    .padding(20)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(zodiacSign.element.color.color.opacity(0.6))
    }
}
