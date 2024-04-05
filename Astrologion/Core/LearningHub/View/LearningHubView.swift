import SwiftUI

struct LearningHubView: View {
    @ObservedObject var viewModel: LearningHubViewModel

    init(viewModel: LearningHubViewModel) {
        self.viewModel = viewModel

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Color.theme.darkBlue)
        appearance.titleTextAttributes = [.foregroundColor: UIColor(Color.theme.lightLavender)]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        NavigationView {
            ScrollView {
                ForEach(Lessons.allCases, id: \.self) { lesson in
                    VStack(alignment: .leading) {
                        Text(lesson.rawValue)
                            .font(.title)
                            .padding(.leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.chapters(for: lesson)) { chapter in
                                    LessonItemView(chapter: chapter)
                                }
                            }
                        }
                    }
                    .padding(.bottom)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Astrologion")
                        .font(.custom("PlayfairDisplay-Regular", size: 24))
                        .foregroundColor(Color.theme.yellow)
                }
            }
            .background(Color.theme.darkBlue)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
