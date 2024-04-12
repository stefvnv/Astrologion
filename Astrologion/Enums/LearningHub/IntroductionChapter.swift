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
            return "The Roots of Astrology"
        case .basics:
            return "Fundamental Concepts"
        case .importance:
            return "Why Astrology Matters"
        }
    }

    var imageName: String {
        return "\(self.title)-thumbnail".lowercased()
    }
}
