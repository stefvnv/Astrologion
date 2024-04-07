import SwiftUI

struct AspectExpandedView: View {
    let leadingPlanet: String
    let trailingPlanet: String
    let aspectType: Aspect
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack {
                GeometryReader { geo in
                    ZStack(alignment: .topLeading) {
                        Image(aspectType.image)
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

                Text("\(leadingPlanet) \(aspectType.relationship) \(trailingPlanet)")
                    .font(.largeTitle)
                    .padding()

                Text(aspectType.symbol)
                    .font(.title)
                    .padding()

                let aspectDetails = aspectType.description(forLeadingPlanet: leadingPlanet, trailingPlanet: trailingPlanet)
                
                Text(aspectDetails.title)
                    .font(.title2)
                    .padding()

                Text(aspectDetails.description)
                    .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}
