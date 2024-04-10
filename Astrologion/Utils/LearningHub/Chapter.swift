import Foundation

struct Chapter: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let imageName: String
    let lessonCategory: Lessons
}
