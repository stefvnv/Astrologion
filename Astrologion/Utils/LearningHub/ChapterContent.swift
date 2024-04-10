import Foundation

struct ChapterContent: Identifiable, Codable {
    let id = UUID()
    let chapter: String
    let parts: [LessonContent]
}
