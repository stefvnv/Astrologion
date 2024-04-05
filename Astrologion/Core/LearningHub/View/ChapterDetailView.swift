import SwiftUI

struct ChapterDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewModel: LearningHubViewModel
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
                    Button(action: {
                        selectedPartNumber -= 1
                    }) {
                        Image("previous") // Replace with your previous icon asset
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30) // Adjust the size as needed
                    }
                }

                Spacer()

                if selectedPartNumber < chapterContent.count {
                    Button(action: {
                        if selectedPartNumber == chapterContent.count - 1 {
                            // Automatically mark as complete when moving to the last part
                            isCompleted = true
                            viewModel.markChapterAsComplete(chapterTitle, isCompleted: isCompleted)
                        }
                        selectedPartNumber += 1
                    }) {
                        Image("next") // Replace with your next icon asset
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30) // Adjust the size as needed
                    }
                }
            }
            .padding()
        }
        .navigationBarTitle(Text("\(chapterTitle): Part \(selectedPartNumber)"), displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading: backButton,
            trailing: Button(action: {
                isCompleted.toggle()
                viewModel.markChapterAsComplete(chapterTitle, isCompleted: isCompleted)
            }) {
                Image(isCompleted ? "complete" : "incomplete")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
            }
        )
    }

    var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(Color.theme.lightLavender)
        }
    }
}
