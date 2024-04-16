import SwiftUI

struct CustomInputView: View {
    @Binding var inputText: String
    let placeholder: String
    let buttonTitle: String
    var action: () -> Void
    
    var body: some View {
        ZStack(alignment: .trailing) {
            ZStack(alignment: .leading) {
                if inputText.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color.white.opacity(0.4))
                        .padding(12)
                        .padding(.leading, 4)
                        .padding(.trailing, 48)
                        .font(.custom("Dosis", size: 14))
                }
                TextField("", text: $inputText, axis: .vertical)
                    .padding(12)
                    .padding(.leading, 4)
                    .padding(.trailing, 48)
                    .background(Color.theme.lavender.opacity(0.3))
                    .clipShape(Capsule())
                    .font(.custom("Dosis", size: 14))
                    .foregroundColor(.white)
            }

            Button(action: action) {
                Text(buttonTitle)
                    .font(.custom("Dosis", size: 14))
                    .fontWeight(.semibold)
                    .foregroundColor(Color.theme.yellow)
            }
            .padding(.horizontal)
            .padding(.trailing, 8)
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
    }
}
