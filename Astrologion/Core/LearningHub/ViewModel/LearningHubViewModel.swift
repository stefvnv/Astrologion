import Foundation

class LearningHubViewModel: ObservableObject {
    @Published var chapters: [Chapter] = []
    @Published var chapterContents: [ChapterContent] = []

    init() {
        loadChapters()
        
        loadChapterContents(forLesson: "Introduction")
        loadChapterContents(forLesson: "ZodiacSigns")
        loadChapterContents(forLesson: "Planets")
        loadChapterContents(forLesson: "Houses")
        loadChapterContents(forLesson: "Aspects")
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

    private func loadChapterContents(forLesson lesson: String) {
        guard let url = Bundle.main.url(forResource: "\(lesson)Chapters", withExtension: "json") else {
            fatalError("\(lesson)Chapters.json not found.")
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let decodedContents = try decoder.decode([ChapterContent].self, from: data)
            chapterContents.append(contentsOf: decodedContents)
        } catch {
            fatalError("Failed to decode \(lesson)Chapters.json: \(error)")
        }
    }

    func contents(for chapterTitle: String) -> [LessonContent] {
        guard let content = chapterContents.first(where: { $0.chapter == chapterTitle }) else {
            return []
        }
        return content.parts
    }
    
    // MARK: - Chapter completion

    func markChapterAsComplete(_ chapterTitle: String, isCompleted: Bool) {
        UserDefaults.standard.set(isCompleted, forKey: chapterTitle)
    }

    func isChapterCompleted(_ chapterTitle: String) -> Bool {
        return UserDefaults.standard.bool(forKey: chapterTitle)
    }
}
