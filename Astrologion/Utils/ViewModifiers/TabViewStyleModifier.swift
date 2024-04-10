import SwiftUI

struct TabViewStyleModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Dosis", size: 13))
            .padding(.vertical, 6)
            .background(Color.theme.darkBlue)
            .foregroundColor(Color.gray)
    }
}

extension View {
    func styledTabView() -> some View {
        self.modifier(TabViewStyleModifier())
    }
}
