enum PlanetsChapter: String, CaseIterable {
    case sun = "Sun"
    case moon = "Moon"
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
        return "\(self.rawValue)-thumbnail".lowercased()
    }
}
