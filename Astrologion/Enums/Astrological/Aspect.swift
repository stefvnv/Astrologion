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
    
    var description: String {
        switch self {
        case .conjunction: return "Conjunction"
        case .sextile: return "Sextile"
        case .square: return "Square"
        case .trine: return "Trine"
        case .opposition: return "Opposition"
        }
    }
}

