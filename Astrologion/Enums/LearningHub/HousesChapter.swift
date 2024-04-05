enum HousesChapter: String, CaseIterable {
    case first = "First House"
    case second = "Second House"
    case third = "Third House"
    case fourth = "Fourth House"
    case fifth = "Fifth House"
    case sixth = "Sixth House"
    case seventh = "Seventh House"
    case eighth = "Eighth House"
    case ninth = "Ninth House"
    case tenth = "Tenth House"
    case eleventh = "Eleventh House"
    case twelfth = "Twelfth House"

    var title: String {
        return self.rawValue
    }

    var subtitle: String {
        switch self {
        case .first:
            return "Self"
        case .second:
            return "Values"
        case .third:
            return "Communications"
        case .fourth:
            return "Home"
        case .fifth:
            return "Pleasure"
        case .sixth:
            return "Health"
        case .seventh:
            return "Partnership"
        case .eighth:
            return "Transformation"
        case .ninth:
            return "Purpose"
        case .tenth:
            return "Social Status"
        case .eleventh:
            return "Friendships"
        case .twelfth:
            return "Subconscious"
        }
    }

    var imageName: String {
        return "\(self.rawValue)-thumbnail".lowercased()
    }
}
