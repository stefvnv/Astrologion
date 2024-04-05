import Foundation



struct Chapter: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let lessonCategory: Lessons
}


struct Lesson: Identifiable { // to be deleted probably
    let id = UUID()
    let title: String
    let parts: [LessonContent] 
    let category: Lessons
    var isCompleted: Bool = false
}




// FOR JSON

struct ChapterContent: Identifiable, Codable {
    let id = UUID()
    let chapter: String
    let parts: [LessonContent]
}

struct LessonContent: Identifiable, Codable {
    let id = UUID()
    let partNumber: Int
    let partTitle: String
    let description: String
}


