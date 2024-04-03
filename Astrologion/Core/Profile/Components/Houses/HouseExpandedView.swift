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
                        Image(house.image) // Use imageName to get the correct Image
                            .resizable() // This should now work as expected
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

                // Fetch the description with correct parameters
                Text(house.description(forSign: zodiacSign.rawValue)) // Make sure 'description(forSign:)' is the correct function
                    .padding()
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}
