import UIKit

/// Represents the major astrological planets, each with an associated symbol
public enum Point: String, CaseIterable {
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
}


/// Extension for `AstrologicalPoint` adding functionality related to color representation and calculating longitude using an astrological service
extension Point {
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
    
    
    
    /// Calculates the longitude of the body using the provided `AstrologyModel` service
    func longitude(using service: AstrologyModel) -> Double {
        switch self {
        case .Sun:
            return service.sunLongitude
        case .Moon:
            return service.moonLongitude
        case .Mercury:
            return service.mercuryLongitude
        case .Venus:
            return service.venusLongitude
        case .Mars:
            return service.marsLongitude
        case .Jupiter:
            return service.jupiterLongitude
        case .Saturn:
            return service.saturnLongitude
        case .Uranus:
            return service.uranusLongitude
        case .Neptune:
            return service.neptuneLongitude
        case .Pluto:
            return service.plutoLongitude
        case .NorthNode:
            return service.northNodeLongitude
        case .Lilith:
            return service.lilithLongitude
        case .Ascendant:
            return service.ascendant
        case .Midheaven:
            return service.midheavenLongitude
        }
    }
}

