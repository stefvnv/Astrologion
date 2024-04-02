import SwiftUI

struct AspectExpandedView: View {
    let leadingPlanet: String
    let trailingPlanet: String
    let aspectType: Aspect
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack {
                // Image at the top
                GeometryReader { geo in
                    ZStack(alignment: .topLeading) {
                        // Aspect image
                        Image(aspectType.image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width, height: geo.size.height)
                            .clipped()

                        // Back button
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
                .frame(height: 300) // Adjust height as needed

                // Title
                Text("\(leadingPlanet) \(aspectType.relationship) \(trailingPlanet)")
                    .font(.largeTitle)
                    .padding()

                // Aspect symbol
                Text(aspectType.symbol)
                    .font(.title)
                    .padding()

                // Keyword
                Text(aspectType.keyword)
                    .font(.title2)
                    .padding()

                // Description
                Text(aspectType.description(forLeadingPlanet: leadingPlanet, trailingPlanet: trailingPlanet))
                    .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}
