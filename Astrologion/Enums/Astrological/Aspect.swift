import UIKit

/// Represents the main astrological aspects in a natal chart
public enum Aspect: CaseIterable {
    case conjunction
    case sextile
    case square
    case trine
    case opposition
    
    var color: AspectColor {
        switch self {
        case .conjunction: return .lightGreen
        case .sextile: return .darkGreen
        case .square: return .pink
        case .trine: return .red
        case .opposition: return .orange
        }
    }

    var uiColor: UIColor {
        return self.color.uiColor
    }
    
    var angle: Double {
        switch self {
        case .conjunction: return 0
        case .sextile: return 60
        case .square: return 90
        case .trine: return 120
        case .opposition: return 180
        }
    }

    var orb: Double {
        switch self {
        case .conjunction: return 8
        case .sextile: return 6
        case .square: return 8
        case .trine: return 8
        case .opposition: return 8
        }
    }
    
    /// Converts a string description to an `Aspect` enum value
    static func from(description: String) -> Aspect? {
        switch description.lowercased() {
            case "conjunction": return .conjunction
            case "sextile": return .sextile
            case "square": return .square
            case "trine": return .trine
            case "opposition": return .opposition
            default: return nil
        }
    }
}
