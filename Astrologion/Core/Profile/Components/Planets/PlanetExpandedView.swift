import SwiftUI

// TODO: format
struct PlanetExpandedView: View {
    let planet: Planet
    let zodiacSign: ZodiacSign
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
                .frame(height: 300) // Adjust the height as needed

                Text("\(planet.rawValue) in \(zodiacSign.rawValue)")
                    .font(.largeTitle)
                    .padding()

                HStack(spacing: 16) { // Add spacing if needed
                    VStack {
                        Text("Element")
                        zodiacSign.element.symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60) // Adjust symbol size as needed
                    }
                    VStack {
                        Text("Modality")
                        zodiacSign.modality.symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60) // Adjust symbol size as needed
                    }
                    VStack {
                        Text("Polarity")
                        zodiacSign.polarity.symbol
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60) // Adjust symbol size as needed
                    }
                }
                .font(.title2)
                .padding()

                Text(zodiacSign.description(for: planet))
                    .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}
