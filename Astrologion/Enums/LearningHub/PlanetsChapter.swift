enum PlanetsChapter: String, CaseIterable {
    case planetsOverview = "The Planets"
    case sun = "The Sun"
    case moon = "The Moon"
    case mercury = "Mercury"
    case venus = "Venus"
    case mars = "Mars"
    case jupiter = "Jupiter"
    case saturn = "Saturn"
    case uranus = "Uranus"
    case neptune = "Neptune"
    case pluto = "Pluto"

    var title: String {
        return self.rawValue
    }

    var subtitle: String {
        switch self {
        case .planetsOverview:
            return "Overview of Planetary Influences"
        case .sun:
            return "Vitality"
        case .moon:
            return "Emotions"
        case .mercury:
            return "Communication"
        case .venus:
            return "Love"
        case .mars:
            return "Action"
        case .jupiter:
            return "Expansion"
        case .saturn:
            return "Restriction"
        case .uranus:
            return "Innovation"
        case .neptune:
            return "Imagination"
        case .pluto:
            return "Transformation"
        }
    }

    var imageName: String {
        switch self {
        case .sun:
            return "sun-thumbnail"
        case .moon:
            return "moon-thumbnail"
        case .planetsOverview:
            return "planetsoverview-thumbnail"
        default:
            return "\(self.rawValue.lowercased())-thumbnail"
        }
    }
}
