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
                        .font(.headline)
                    Text(signWithDegree)
                        .font(.subheadline)
                }
                Spacer()
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .overlay(
                ZStack {
                    Circle()
                        .stroke(lineWidth: 2)
                        .frame(width: 60, height: 60)
                    Text(house.romanNumeral)
                        .font(.title)
                }
                .offset(x: 30), // Move the circle to the right
                alignment: .trailing
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.trailing, 30) // Offset for alignment
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
