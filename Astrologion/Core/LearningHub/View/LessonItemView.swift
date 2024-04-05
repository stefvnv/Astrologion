import SwiftUI

struct LessonItemView: View {
    @EnvironmentObject var viewModel: LearningHubViewModel
    let chapter: Chapter
    @State private var isCompleted = false 

    var body: some View {
        NavigationLink(destination: ChapterDetailView(chapterContent: viewModel.contents(for: chapter.title), chapterTitle: chapter.title, isCompleted: $isCompleted)) {
            VStack(spacing: 0) {
                Text(chapter.title)
                    .textCase(.uppercase)
                    .foregroundColor(Color.theme.darkBlue)
                    .padding()
                    .frame(width: 150, height: 40)
                    .background(Color.theme.lightLavender)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.bottom, -2)

                Image(chapter.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.theme.lightLavender, lineWidth: 2)
                    )
            }
        }
        .buttonStyle(PlainButtonStyle()) // This removes the default NavigationLink styling
        .padding(.leading)
    }
}
