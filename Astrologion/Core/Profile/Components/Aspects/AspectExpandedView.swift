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
                    .font(Font.custom("PlayfairDisplay-Regular", size: 26))
                    .foregroundColor(Color.theme.purple)
                    .padding()

                Text(aspectType.symbol)
                    .font(.system(size: 30))
                    .foregroundColor(Color(uiColor: aspectType.darkerColor))
                    .padding()

                let aspectDetails = aspectType.description(forLeadingPlanet: leadingPlanet, trailingPlanet: trailingPlanet)
                
                Text(aspectDetails.title)
                    .font(.custom("Dosis", size: 20))
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .background(
                        RoundedRectangle(cornerRadius: 26)
                            .foregroundColor(Color(aspectType.uiColor))
                    )
                    .padding(.vertical, 15)

                Text(aspectDetails.description)
                    .font(.custom("Dosis", size: 18))
                    .foregroundColor(Color.theme.darkBlue)
                    .padding(20)
            }
        }
        .background(Color(aspectType.uiColor).opacity(0.2))
        .ignoresSafeArea(edges: .top)
    }
}
