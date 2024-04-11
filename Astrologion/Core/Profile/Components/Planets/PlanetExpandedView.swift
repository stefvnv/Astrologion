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
                    .font(Font.custom("PlayfairDisplay-Regular", size: 28))
                    .foregroundColor(.purple)
                    .padding()

                HStack(spacing: 16) {
                    VStack {
                        //Text("Element")
                        zodiacSign.element.symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    VStack {
                        //Text("Modality")
                        zodiacSign.modality.symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    VStack {
                        //Text("Polarity")
                        zodiacSign.polarity.symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                }
                .font(.title2)
                .padding()

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
        .background(Color.theme.lightLavender)
    }
}
