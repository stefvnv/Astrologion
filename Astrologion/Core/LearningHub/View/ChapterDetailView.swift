import SwiftUI

struct ChapterDetailView: View {
    var chapterContent: [LessonContent]
    var chapterTitle: String
    @Binding var isCompleted: Bool
    @State private var selectedPartNumber = 1

    var body: some View {
        VStack {
            if let selectedPart = chapterContent.first(where: { $0.partNumber == selectedPartNumber }) {
                PartView(lessonContent: selectedPart)
            }

            HStack {
                if selectedPartNumber > 1 {
                    Button("Previous") {
                        selectedPartNumber -= 1
                    }
                }

                Spacer()

                if selectedPartNumber < chapterContent.count {
                    Button("Next") {
                        selectedPartNumber += 1
                    }
                } else { // Last page
                    Button("Complete") {
                        isCompleted = true
                        // Here you can add logic to mark the chapter as completed
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle(Text("\(chapterTitle): Part \(selectedPartNumber)"), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton, trailing: isCompleted ? Image("complete") : nil)
    }

    var backButton: some View {
        Button(action: {
            // action to pop view
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(Color.theme.lightLavender)
        }
    }
}
