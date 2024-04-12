enum ZodiacSignsChapter: String, CaseIterable {
    case zodiacOverview = "The Zodiac"
    case aries = "Aries"
    case taurus = "Taurus"
    case gemini = "Gemini"
    case cancer = "Cancer"
    case leo = "Leo"
    case virgo = "Virgo"
    case libra = "Libra"
    case scorpio = "Scorpio"
    case sagittarius = "Sagittarius"
    case capricorn = "Capricorn"
    case aquarius = "Aquarius"
    case pisces = "Pisces"

    var title: String {
        return self.rawValue
    }

    var subtitle: String {
        switch self {
        case .zodiacOverview:
            return "What is the Zodiac?"
        case .aries:
            return "The Ram"
        case .taurus:
            return "The Bull"
        case .gemini:
            return "The Twins"
        case .cancer:
            return "The Crab"
        case .leo:
            return "The Lion"
        case .virgo:
            return "The Virgin"
        case .libra:
            return "The Scales"
        case .scorpio:
            return "The Scorpion"
        case .sagittarius:
            return "The Archer"
        case .capricorn:
            return "The Goat"
        case .aquarius:
            return "The Water Bearer"
        case .pisces:
            return "The Fish"
        }
    }

    var imageName: String {
        switch self {
        case .zodiacOverview:
            return "zodiacoverview-thumbnail"
        default:
            return "\(self.rawValue.lowercased())-thumbnail"
        }
    }
}
