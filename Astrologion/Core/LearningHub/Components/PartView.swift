import SwiftUI

struct PartView: View {
    let lessonContent: LessonContent
    
    var body: some View {
        ScrollView {
            VStack {
                Text(lessonContent.partTitle)
                    .font(.custom("Dosis", size: 22))
                    .foregroundColor(Color.theme.purple)
                    .fontWeight(.bold)
                    .padding(.top, 34)
                    
                Text(lessonContent.description)
                    .font(.custom("Dosis", size: 18))
                    .multilineTextAlignment(.leading)
                    .padding()
            }
        }
    }
}
