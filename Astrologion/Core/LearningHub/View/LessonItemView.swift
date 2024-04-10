import SwiftUI

struct LessonItemView: View {
    @EnvironmentObject var viewModel: LearningHubViewModel
    let chapter: Chapter
    @State private var isCompleted = false
    
    var body: some View {
        VStack {
            NavigationLink(destination: ChapterDetailView(chapterContent: viewModel.contents(for: chapter.title), chapterTitle: chapter.title, isCompleted: $isCompleted)
                .environmentObject(viewModel)) {
                    VStack(spacing: 0) {
                        Text(chapter.title)
                            .font(Font.custom("Dosis", size: 16).bold()) 
                            .textCase(.uppercase)
                            .foregroundColor(Color.theme.darkBlue)
                            .padding()
                            .frame(width: 150, height: 40)
                            .background(Color.theme.lightLavender)
                            .clipShape(TopRoundedRectangle(radii: 8))
                        
                        
                        Image(chapter.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 200)
                            .clipShape(BottomRoundedRectangle(radii: 10))
                            .overlay(
                                BottomRoundedRectangle(radii: 10)
                                    .stroke(Color.theme.lightLavender, lineWidth: 1)
                            )
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.leading)
                .onAppear {
                    isCompleted = viewModel.isChapterCompleted(chapter.title)
                }
                .overlay(isCompleted ? Image("complete")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 35, height: 35)
                    .padding(.top, -10)
                    .padding(.trailing, -10)
                    .alignmentGuide(.top) { d in d[.top] - 8 }
                    .alignmentGuide(.trailing) { d in d[.trailing] - 8 }
                         : nil, alignment: .topTrailing)
        }
        .padding(.top, 10) 
    }
}
