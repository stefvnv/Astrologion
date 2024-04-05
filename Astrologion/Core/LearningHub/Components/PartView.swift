import SwiftUI

// TODO: styling
struct PartView: View {
    let lessonContent: LessonContent
    
    var body: some View {
        ScrollView {
            VStack {
                Text(lessonContent.partTitle)
                    .font(.headline)
                    .padding()
                
                Text(lessonContent.description)
                    .font(.body)
                    .padding()
            }
        }
    }
}
