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
                    .font(.largeTitle)
                    .padding()

                HStack(spacing: 16) {
                    VStack {
                        Text("Element")
                        zodiacSign.element.symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                    VStack {
                        Text("Modality")
                        zodiacSign.modality.symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                    VStack {
                        Text("Polarity")
                        zodiacSign.polarity.symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                    }
                }
                .font(.title2)
                .padding()

                // sign description
                Text(zodiacSign.signDescription(for: planet))
                    .padding()
                
                // house description
                Text(house.description(for: planet, house: house))
                    .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}
