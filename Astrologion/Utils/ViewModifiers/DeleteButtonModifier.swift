import SwiftUI

struct DeleteButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Dosis", size: 16))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(width: 360, height: 44)
            .background(.red).opacity(0.4)
            .cornerRadius(8)
            .padding()
    }
}
