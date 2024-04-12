enum AspectsChapter: String, CaseIterable {
    case aspectsOverview = "The Aspects"
    case conjunction = "Conjunction"
    case sextile = "Sextile"
    case square = "Square"
    case trine = "Trine"
    case opposition = "Opposition"
    case minorAspects = "Minor Aspects"

    var title: String {
        switch self {
        case .aspectsOverview:
            return "The Aspects"
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
        case .aspectsOverview:
            return "Astrological Aspects"
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
        switch self {
        case .aspectsOverview:
            return "aspectsoverview-thumbnail"
        case .minorAspects:
            return "minor"
        default:
            return "\(self.rawValue)".lowercased()
        }
    }
}
