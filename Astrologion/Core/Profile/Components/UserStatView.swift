import SwiftUI

struct UserStatView: View {
    let value: Int?
    let title: String
    
    var body: some View {
        VStack {
            Text("\(value ?? 0)")
                .font(.custom("Dosis", size: 12).weight(.semibold))
                .foregroundColor(Color.theme.darkBlue)
            
            Text(title)
                .font(.custom("Dosis", size: 12))
                .foregroundColor(Color.theme.darkBlue)
        }
        .opacity(value == 0 ? 0.5 : 1.0)
        .frame(width: 50, height: 40, alignment: .center)
        .padding(2)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.theme.lavender, lineWidth: 1)
        )
    }
}

struct UserStatView_Previews: PreviewProvider {
    static var previews: some View {
        UserStatView(value: 1, title: "Posts")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
