import SwiftUI

struct PartView: View {
    let lessonContent: LessonContent

    var body: some View {
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
