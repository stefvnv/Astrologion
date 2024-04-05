enum IntroductionChapter: String, CaseIterable {
    case history = "History of Astrology"
    case basics = "Basics of Astrology"
    case importance = "Importance of Astrology"

    var title: String {
        switch self {
        case .history:
            return "History"
        case .basics:
            return "Basics"
        case .importance:
            return "Importance"
        }
    }

    var subtitle: String {
        switch self {
        case .history:
            return "Explore the roots of astrology."
        case .basics:
            return "Understand the fundamental concepts."
        case .importance:
            return "Discover why astrology matters."
        }
    }

    var imageName: String {
        return "\(self.title)-thumbnail".lowercased()
    }
}
