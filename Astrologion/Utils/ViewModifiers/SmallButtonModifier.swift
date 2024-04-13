import SwiftUI

struct SmallButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Dosis", size: 12))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 120, height: 40)
            .background(Color.theme.lavender)
            .cornerRadius(8)
            .padding()
    }
}
