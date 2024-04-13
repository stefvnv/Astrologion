import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Dosis", size: 16))
            .padding(12)
            .foregroundColor(.white)
            .background(Color.theme.lavender).opacity(0.9)
            .cornerRadius(10)
            .padding(.horizontal, 24)
    }
}
