enum NatalChartChapter: String, CaseIterable {
    case interpretation = "Interpreting a Natal Chart"
    case components = "Components of a Natal Chart"
    case aspects = "Astrological Aspects"
    case houses = "Astrological Houses"
    case planets = "Astrological Planets"
    case moonPhases = "Moon Phases"
    
    var title: String {
        switch self {
        case .interpretation:
            return "Interpretation"
        case .components:
            return "Components"
        case .aspects:
            return "Aspects"
        case .houses:
            return "Houses"
        case .planets:
            return "Planets"
        case .moonPhases:
            return "Moon Phases"
        }
    }

    var subtitle: String {
        switch self {
        case .interpretation:
            return "Learn how to interpret a natal chart."
        case .components:
            return "Understand the different components of a natal chart."
        case .aspects:
            return "Explore the astrological aspects in a natal chart."
        case .houses:
            return "Discover the significance of astrological houses in a natal chart."
        case .planets:
            return "Understand the roles and meanings of astrological planets in a natal chart."
        case .moonPhases:
            return "Learn about the significance of moon phases in a natal chart."
        }
    }

    var imageName: String {
        return "\(self.rawValue)-thumbnail".lowercased()
    }
}
