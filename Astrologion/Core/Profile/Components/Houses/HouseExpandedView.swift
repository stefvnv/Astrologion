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
                    .font(Font.custom("PlayfairDisplay-Regular", size: 28))
                    .foregroundColor(.purple)
                    .padding()

                VStack {
                    Text(house.keyword)
                        .font(.custom("Dosis", size: 22))
                        .foregroundColor(Color.theme.darkBlue)
                        .padding()
                }
                .padding()

                Text(house.cuspDescription(forSign: zodiacSign.rawValue))
                    .font(.custom("Dosis", size: 18))
                    .foregroundColor(Color.theme.darkBlue)
                    .padding(20)
            }
        }
        .background(Color.theme.lightLavender)
        .ignoresSafeArea(edges: .top)
    }
}
