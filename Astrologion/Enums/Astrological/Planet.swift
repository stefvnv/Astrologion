import UIKit


/// Represents the major astrological planets, each with an associated symbol
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
    
    /// The astrological symbol associated with the body
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
        case .Ascendant, .Midheaven: return nil // no symbol returned
        }
    }

    /// Calculates the longitude of the body using the provided `AstrologyModel` service
    func longitude(using model: AstrologyModel) -> Double {
        switch self {
        case .Sun:
            return model.sunLongitude
        case .Moon:
            return model.moonLongitude
        case .Mercury:
            return model.mercuryLongitude
        case .Venus:
            return model.venusLongitude
        case .Mars:
            return model.marsLongitude
        case .Jupiter:
            return model.jupiterLongitude
        case .Saturn:
            return model.saturnLongitude
        case .Uranus:
            return model.uranusLongitude
        case .Neptune:
            return model.neptuneLongitude
        case .Pluto:
            return model.plutoLongitude
        case .NorthNode:
            return model.northNodeLongitude
        case .Lilith:
            return model.lilithLongitude
        case .Ascendant:
            return model.ascendant
        case .Midheaven:
            return model.midheavenLongitude
        }
    }
    
    ///
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
