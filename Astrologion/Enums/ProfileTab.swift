enum ProfileTab: Int, CaseIterable {
    case chart
    case planets
    case houses
    case aspects
    case summary
    
    // TODO: ADD ICONS
    var text: String {
        switch self {
        case .chart:
            return "Chart"
        case .planets:
            return "Planets"
        case .houses:
            return "Houses"
        case .aspects:
            return "Aspects"
        case .summary:
            return "Summary"
        }
    }
}
