import Foundation

struct Lesson: Identifiable {
    let id = UUID()
    let title: String
    let parts: [LessonContent]
    let category: Lessons
    var isCompleted: Bool = false
}
