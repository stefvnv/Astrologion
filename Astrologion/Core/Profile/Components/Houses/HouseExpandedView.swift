import SwiftUI

struct HouseExpandedView: View {
    let house: House
    let zodiacSign: ZodiacSign
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            VStack {
                GeometryReader { geo in
                    ZStack(alignment: .topLeading) {
                        Image(house.image)
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

                Text("\(house.formattedName) in \(zodiacSign.rawValue)")
                    .font(.largeTitle)
                    .padding()

                VStack {
                    Text("Keyword")
                        .font(.title2)
                    Text(house.keyword)
                        .font(.title)
                }
                .padding()

                Text(house.cuspDescription(forSign: zodiacSign.rawValue))
                    .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}
