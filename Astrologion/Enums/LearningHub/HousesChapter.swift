enum HousesChapter: String, CaseIterable {
    case housesOverview = "The Houses"
    case first = "First"
    case second = "Second"
    case third = "Third"
    case fourth = "Fourth"
    case fifth = "Fifth"
    case sixth = "Sixth"
    case seventh = "Seventh"
    case eighth = "Eighth"
    case ninth = "Ninth"
    case tenth = "Tenth"
    case eleventh = "Eleventh"
    case twelfth = "Twelfth"

    var title: String {
        return self.rawValue
    }

    var subtitle: String {
        switch self {
        case .housesOverview:
            return "The Houses"
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
        switch self {
        case .housesOverview:
            return "housesoverview-thumbnail"
        default:
            return "\(self.rawValue)-thumbnail".lowercased()
        }
    }
}
