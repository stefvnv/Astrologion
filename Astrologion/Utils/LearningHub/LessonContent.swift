import Foundation

struct LessonContent: Identifiable, Codable {
    let id = UUID()
    let partNumber: Int
    let partTitle: String
    let description: String
}
