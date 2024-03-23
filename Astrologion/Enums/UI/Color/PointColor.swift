import UIKit

public enum PointColor {
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

    var uiColor: UIColor {
        let color: UIColor? = {
            switch self {
            case .sun: return UIColor(hex: "#FFD700")
            case .moon: return UIColor(hex: "#F0EAD6")
            case .mercury: return UIColor(hex: "#C0C0C0") // grey
            case .venus: return UIColor(hex: "#FFC0CB") // pink
            case .mars: return UIColor(hex: "#FF6347") // red
            case .jupiter: return UIColor(hex: "#FFA07A")
            case .saturn: return UIColor(hex: "#A0522D")
            case .uranus: return UIColor(hex: "#00CED1")
            case .neptune: return UIColor(hex: "#7B68EE")
            case .pluto: return UIColor(hex: "#8B008B")
            case .northNode: return UIColor(hex: "#696969")
            case .lilith: return UIColor(hex: "#FFFFFF")
            case .gold: return UIColor(hex: "#F0D770")
            }
        }()
        
        return color?.withAlphaComponent(0.8) ?? .black
    }
}
