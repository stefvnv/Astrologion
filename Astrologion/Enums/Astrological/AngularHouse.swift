/// Represents the four angular points of a natal chart
public enum AngularHouse: String, CaseIterable {
    case ascendant = "Ascendant"
    case descendant = "Descendant"
    case midheaven = "Midheaven" // MC
    case imumCoeli = "Imum Coeli" // IC

    var symbol: String {
        switch self {
        case .ascendant:
            return "ASC"
        case .descendant:
            return "DSC"
        case .midheaven:
            return "MC"
        case .imumCoeli:
            return "IC"
        }
    }

    var order: Int {
        switch self {
        case .ascendant:
            return 1
        case .midheaven:
            return 10
        case .descendant:
            return 7
        case .imumCoeli:
            return 4
        }
    }
}
