import UIKit

public enum Point: Int32, CaseIterable {
    case Sun = 0 // SE_SUN
    case Moon = 1 // SE_MOON
    case Mercury = 2 // SE_MERCURY
    case Venus = 3 // SE_VENUS
    case Mars = 4 // SE_MARS
    case Jupiter = 5 // SE_JUPITER
    case Saturn = 6 // SE_SATURN
    case Uranus = 7 // SE_URANUS
    case Neptune = 8 // SE_NEPTUNE
    case Pluto = 9 // SE_PLUTO
    case NorthNode = 10 // SE_TRUE_NODE
    case Lilith = 11 // SE_MEAN_APOG
    case Ascendant = -1
    case Midheaven = -2

    var symbol: String? {
        switch self {
        case .Sun: return "☉"
        case .Moon: return "☾"
        case .Mercury: return "☿"
        case .Venus: return "♀"
        case .Mars: return "♂"
        case .Jupiter: return "♃"
        case .Saturn: return "♄"
        case .Uranus: return "♅"
        case .Neptune: return "♆"
        case .Pluto: return "♇"
        case .NorthNode: return "☊"
        case .Lilith: return "⚸"
        case .Ascendant, .Midheaven: return nil
        }
    }

    var color: UIColor {
        switch self {
        case .Sun: return PointColor.sun.uiColor
        case .Moon: return PointColor.moon.uiColor
        case .Mercury: return PointColor.mercury.uiColor
        case .Venus: return PointColor.venus.uiColor
        case .Mars: return PointColor.mars.uiColor
        case .Jupiter: return PointColor.jupiter.uiColor
        case .Saturn: return PointColor.saturn.uiColor
        case .Uranus: return PointColor.uranus.uiColor
        case .Neptune: return PointColor.neptune.uiColor
        case .Pluto: return PointColor.pluto.uiColor
        case .NorthNode: return PointColor.northNode.uiColor
        case .Lilith: return PointColor.lilith.uiColor
        case .Ascendant, .Midheaven: return PointColor.gold.uiColor
        }
    }
}

extension Point: Hashable {}
