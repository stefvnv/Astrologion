import UIKit

public enum PlanetColor {
    case sun
    case moon
    case mercury
    case venus
    case mars
    case jupiter
    case saturn
    case uranus
    case neptune
    case pluto
    case northNode
    case lilith
    case gold // for Ascendant and Midheaven
    case darkSun
    case darkMoon
    case darkMercury
    case darkVenus
    case darkMars
    case darkJupiter
    case darkSaturn
    case darkUranus
    case darkNeptune
    case darkPluto
    case darkNorthNode
    case darkLilith
    case darkGold
    
    var uiColor: UIColor {
        let color: UIColor? = {
            switch self {
            case .sun: return UIColor(hex: "#b59a04")
            case .moon: return UIColor(hex: "#C0BDB6")
            case .mercury: return UIColor(hex: "#808080")
            case .venus: return UIColor(hex: "#D87093")
            case .mars: return UIColor(hex: "#FF6347")
            case .jupiter: return UIColor(hex: "#FFA07A")
            case .saturn: return UIColor(hex: "#A0522D")
            case .uranus: return UIColor(hex: "#00CED1")
            case .neptune: return UIColor(hex: "#7B68EE")
            case .pluto: return UIColor(hex: "#8B008B")
            case .northNode: return UIColor(hex: "#696969")
            case .lilith: return UIColor(hex: "#FFFFFF")
            case .gold: return UIColor(hex: "#F0D770")
            case .darkSun: return UIColor(hex: "#936C00")
            case .darkMoon: return UIColor(hex: "#999999")
            case .darkMercury: return UIColor(hex: "#666666")
            case .darkVenus: return UIColor(hex: "#A0005C")
            case .darkMars: return UIColor(hex: "#C05037")
            case .darkJupiter: return UIColor(hex: "#C87550")
            case .darkSaturn: return UIColor(hex: "#783F04")
            case .darkUranus: return UIColor(hex: "#008B8B")
            case .darkNeptune: return UIColor(hex: "#483D8B")
            case .darkPluto: return UIColor(hex: "#660066")
            case .darkNorthNode: return UIColor(hex: "#505050")
            case .darkLilith: return UIColor(hex: "#E5E5E5")
            case .darkGold: return UIColor(hex: "#B8981D")
            }
        }()
        
        return color?.withAlphaComponent(0.8) ?? .black
    }
}
