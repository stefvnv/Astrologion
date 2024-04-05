import Foundation

class LearningHubViewModel: ObservableObject {
    @Published var chapters: [Chapter] = []
    @Published var chapterContents: [ChapterContent] = []

    init() {
        loadChapters()
        loadChapterContents()
    }

    func loadChapters() {

        chapters = Lessons.allCases.flatMap { lesson -> [Chapter] in
            switch lesson {
            case .introduction:
                return IntroductionChapter.allCases.map {
                    Chapter(title: $0.title, subtitle: $0.subtitle, imageName: $0.imageName, lessonCategory: lesson)
                }
            case .zodiacSigns:
                return ZodiacSignsChapter.allCases.map {
                    Chapter(title: $0.title, subtitle: $0.subtitle, imageName: $0.imageName, lessonCategory: lesson)
                }
            case .planets:
                return PlanetsChapter.allCases.map {
                    Chapter(title: $0.title, subtitle: $0.subtitle, imageName: $0.imageName, lessonCategory: lesson)
                }
            case .houses:
                return HousesChapter.allCases.map {
                    Chapter(title: $0.title, subtitle: $0.subtitle, imageName: $0.imageName, lessonCategory: lesson)
                }
            case .natalChart:
                return NatalChartChapter.allCases.map {
                    Chapter(title: $0.title, subtitle: $0.subtitle, imageName: $0.imageName, lessonCategory: lesson)
                }
            case .aspects:
                return AspectsChapter.allCases.map {
                    Chapter(title: $0.title, subtitle: $0.subtitle, imageName: $0.imageName, lessonCategory: lesson)
                }
            }
        }
    }

    func chapters(for lesson: Lessons) -> [Chapter] {
        return chapters.filter { $0.lessonCategory == lesson }
    }

    private func loadChapterContents() {
        guard let url = Bundle.main.url(forResource: "ZodiacSignChapters", withExtension: "json") else {
            fatalError("ZodiacSignChapters.json not found.")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            chapterContents = try decoder.decode([ChapterContent].self, from: data)
        } catch {
            fatalError("Failed to decode ZodiacSignChapters.json: \(error)")
        }
    }

    func contents(for chapterTitle: String) -> [LessonContent] {
        guard let content = chapterContents.first(where: { $0.chapter == chapterTitle }) else {
            return []
        }
        
        return content.parts
    }
}
