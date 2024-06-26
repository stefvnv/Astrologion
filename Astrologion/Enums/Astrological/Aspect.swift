import UIKit

/// Represents the main astrological aspects in a natal chart
public enum Aspect: String, CaseIterable {
    case conjunction = "Conjunction"
    case sextile = "Sextile"
    case square = "Square"
    case trine = "Trine"
    case opposition = "Opposition"
    
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
    
    var transitOrb: Double {
        switch self {
        case .conjunction: return 2
        case .sextile: return 2
        case .square: return 2
        case .trine: return 2
        case .opposition: return 2
        }
    }
    
    var symbol: String {
        switch self {
        case .conjunction: return "☌"
        case .sextile: return "⚹"
        case .square: return "□"
        case .trine: return "△"
        case .opposition: return "☍"
        }
    }
    
    var keyword: String {
        switch self {
        case .conjunction: return "Unified"
        case .sextile: return "Harmonious"
        case .square: return "Challenging"
        case .trine: return "Flowing"
        case .opposition: return "Tense"
        }
    }
    
    var relationship: String {
        switch self {
        case .conjunction: return "Conjunct"
        case .sextile: return "Sextile"
        case .square: return "Square"
        case .trine: return "Trine"
        case .opposition: return "Opposition"
        }
    }
    
    //TODO: refactor to use rawvalue
    var description: String {
        switch self {
        case .conjunction: return "Conjunction"
        case .sextile: return "Sextile"
        case .square: return "Square"
        case .trine: return "Trine"
        case .opposition: return "Opposition"
        }
    }
    
    var color: AspectColor {
        switch self {
        case .conjunction: return .gold
        case .sextile: return .blue
        case .square: return .red
        case .trine: return .green
        case .opposition: return .orange
        }
    }
    
    var darkerColor: UIColor {
        switch self {
        case .conjunction: return AspectColor.darkGold.uiColor
        case .sextile: return AspectColor.darkBlue.uiColor
        case .square: return AspectColor.darkRed.uiColor
        case .trine: return AspectColor.darkGreen.uiColor
        case .opposition: return AspectColor.darkOrange.uiColor
        }
    }

    var uiColor: UIColor {
        return self.color.uiColor
    }
    
    
    // MARK: - Aspect Expanded View
    
    var image: String {
        return self.rawValue.lowercased()
    }
    
    func description(forLeadingPlanet leadingPlanet: String, trailingPlanet: String) -> (description: String, title: String) {
        let aspectDescriptions = loadAspectDescriptions()
        if let aspectData = aspectDescriptions.first(where: { $0.leadingPlanet == leadingPlanet && $0.trailingPlanet == trailingPlanet && $0.aspectType == self.rawValue }) {
            return (aspectData.description, aspectData.title)
        } else {
            return ("Description not found for \(leadingPlanet) \(self.rawValue) \(trailingPlanet).", "Title not found")
        }
    }

    
    
    // MARK: - Transits

    func isWithinOrb(of angle: Double) -> Bool {
        return abs(self.angle - angle) <= self.transitOrb
    }
    
    
    func involves(_ planet: Planet) -> Bool {
        return self == .conjunction && (planet == .Ascendant || planet == .Midheaven)
    }

} // end
