import SwiftUI

public enum Ruler: String {
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

    var symbol: String {
        switch self {
        case .sun: return "☉"
        case .moon: return "☽"
        case .mercury: return "☿"
        case .venus: return "♀"
        case .mars: return "♂"
        case .jupiter: return "♃"
        case .saturn: return "♄"
        case .uranus: return "♅"
        case .neptune: return "♆"
        case .pluto: return "♇"
        }
    }

    var color: UIColor {
        switch self {
        case .sun: return .systemOrange
        case .moon: return .systemGray
        case .mercury: return .systemGray2
        case .venus: return .systemPink
        case .mars: return .systemRed
        case .jupiter: return .systemYellow
        case .saturn: return .systemBrown
        case .uranus: return .systemTeal
        case .neptune: return .systemBlue
        case .pluto: return .systemPurple
        }
    }
}
