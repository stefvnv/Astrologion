enum AspectsChapter: String, CaseIterable {
    case conjunction = "Conjunction"
    case sextile = "Sextile"
    case square = "Square"
    case trine = "Trine"
    case opposition = "Opposition"
    case minorAspects = "Minor Aspects"

    var title: String {
        switch self {
        case .conjunction:
            return "Conjunction"
        case .sextile:
            return "Sextile"
        case .square:
            return "Square"
        case .trine:
            return "Trine"
        case .opposition:
            return "Opposition"
        case .minorAspects:
            return "Minor Aspects"
        }
    }

    var subtitle: String {
        switch self {
        case .conjunction:
            return "Understand the conjunction aspect in astrology."
        case .sextile:
            return "Understand the sextile aspect in astrology."
        case .square:
            return "Understand the square aspect in astrology."
        case .trine:
            return "Understand the trine aspect in astrology."
        case .opposition:
            return "Understand the opposition aspect in astrology."
        case .minorAspects:
            return "Explore various minor aspects in astrology."
        }
    }

    var imageName: String {
        return "\(self.rawValue)-thumbnail".lowercased()
    }
}
