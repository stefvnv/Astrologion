import UIKit

public enum Planet: String, CaseIterable {
    case Sun = "Sun"
    case Moon = "Moon"
    case Mercury = "Mercury"
    case Venus = "Venus"
    case Mars = "Mars"
    case Jupiter = "Jupiter"
    case Saturn = "Saturn"
    case Uranus = "Uranus"
    case Neptune = "Neptune"
    case Pluto = "Pluto"
    case NorthNode = "North Node"
    case Lilith = "Lilith"
    case Ascendant = "Ascendant"
    case Midheaven = "Midheaven"
    
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
    
    var seIdentifier: Int32? {
        switch self {
        case .Sun: return SE_SUN
        case .Moon: return SE_MOON
        case .Mercury: return SE_MERCURY
        case .Venus: return SE_VENUS
        case .Mars: return SE_MARS
        case .Jupiter: return SE_JUPITER
        case .Saturn: return SE_SATURN
        case .Uranus: return SE_URANUS
        case .Neptune: return SE_NEPTUNE
        case .Pluto: return SE_PLUTO
        case .NorthNode: return SE_TRUE_NODE
        case .Lilith: return SE_MEAN_APOG
        case .Ascendant, .Midheaven:
            return nil
        }
    }
    
    func longitude(using model: AstrologyModel) -> Double? {
        switch self {
        case .Ascendant:
            return model.ascendant
        case .Midheaven:
            return model.midheavenLongitude
        default:
            return model.planetPositions[self]?.longitude
        }
    }

    var color: UIColor {
        switch self {
        case .Sun: return PlanetColor.sun.uiColor
        case .Moon: return PlanetColor.moon.uiColor
        case .Mercury: return PlanetColor.mercury.uiColor
        case .Venus: return PlanetColor.venus.uiColor
        case .Mars: return PlanetColor.mars.uiColor
        case .Jupiter: return PlanetColor.jupiter.uiColor
        case .Saturn: return PlanetColor.saturn.uiColor
        case .Uranus: return PlanetColor.uranus.uiColor
        case .Neptune: return PlanetColor.neptune.uiColor
        case .Pluto: return PlanetColor.pluto.uiColor
        case .NorthNode: return PlanetColor.northNode.uiColor
        case .Lilith: return PlanetColor.lilith.uiColor
        case .Ascendant, .Midheaven: return PlanetColor.gold.uiColor
        }
    }
}
