import SwiftUI

struct PlanetImage: View {
    var name: String
    
    var body: some View {
        Image(name.lowercased())
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 60)
            .padding(.horizontal, 20)
    }
}
