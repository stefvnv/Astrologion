import SwiftUI

struct HouseDetailView: View {
    let house: House
    let signWithDegree: String
    @State private var showExpandedView = false

    var body: some View {
        Button(action: {
            showExpandedView = true
        }) {
            content
        }
        .sheet(isPresented: $showExpandedView) {
            let components = signWithDegree.split(separator: " ")
            if let zodiacEnum = ZodiacSign(rawValue: String(components[0])) {
                HouseExpandedView(house: house, zodiacSign: zodiacEnum)
            } else {
                Text("Invalid Zodiac Sign")
            }
        }
    }

    @ViewBuilder
    var content: some View {
        ZStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(house.formattedName)
                        .font(.custom("PlayfairDisplay-Regular", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(Color.theme.purple)
                    Text(signWithDegree)
                        .font(.custom("Dosis", size: 16))
                        .fontWeight(.regular)
                        .foregroundColor(Color.theme.darkBlue)
                }
                Spacer()
            }
            .padding()
            .background(Color.theme.purple.opacity(0.15))
            .cornerRadius(10)
            .overlay(
                Image(house.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .offset(x: 30),
                alignment: .trailing
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.trailing, 30)
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct HouseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        HouseDetailView(house: .first, signWithDegree: "Aries 23°")
            .previewLayout(.sizeThatFits)
    }
}
