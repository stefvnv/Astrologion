import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Dosis", size: 16))
            .padding(12)
            .background(Color.theme.lavender).opacity(0.3)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal, 24)
    }
}
