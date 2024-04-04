import Foundation

struct Transit: Identifiable {
    let id = UUID()
    let planet: Planet
    let sign: ZodiacSign
    let house: Int
    let aspect: Aspect
    let natalPlanet: Planet
    let longitude: Double

    
    // MARK: - Transit Planet Detail View

    func title(from transitDescriptions: [TransitDescription]) -> String {
        let transitKey = descriptionKey()
        if let descriptionData = transitDescriptions.first(where: {
            $0.transit.compare(transitKey, options: .caseInsensitive) == .orderedSame
        }) {
            return descriptionData.title
        } else {
            return "Unknown Transit"
        }
    }

    func description(from transitDescriptions: [TransitDescription]) -> String {
        let transitKey = descriptionKey()
        if let descriptionData = transitDescriptions.first(where: {
            $0.transit.compare(transitKey, options: .caseInsensitive) == .orderedSame
        }) {
            return descriptionData.description
        } else {
            return "No description available for \(transitKey)."
        }
    }

    func descriptionKey() -> String {
        let components = [
            planet.rawValue,
            aspect.rawValue,
            natalPlanet.rawValue
        ]
        let transitKey = components.joined(separator: " ").trimmingCharacters(in: .whitespacesAndNewlines)
        return transitKey
    }
}
