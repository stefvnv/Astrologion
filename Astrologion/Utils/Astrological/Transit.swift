import Foundation

struct Transit: Identifiable {
    let id = UUID()
    let planet: Planet
    let sign: ZodiacSign
    let house: Int
    let aspects: [Aspect]
    let natalPlanet: Planet
    let longitude: Double

    func title(from transitDescriptions: [TransitDescription], for aspect: Aspect) -> String {
        let transitKey = descriptionKey(for: aspect)
        if let descriptionData = transitDescriptions.first(where: {
            $0.transit.compare(transitKey, options: .caseInsensitive) == .orderedSame
        }) {
            return descriptionData.title
        } else {
            return "Unknown Transit"
        }
    }

    func description(from transitDescriptions: [TransitDescription], for aspect: Aspect) -> String {
        let transitKey = descriptionKey(for: aspect)
        if let descriptionData = transitDescriptions.first(where: {
            $0.transit.compare(transitKey, options: .caseInsensitive) == .orderedSame
        }) {
            return descriptionData.description
        } else {
            return "No description available for \(transitKey)."
        }
    }

    func descriptionKey(for aspect: Aspect) -> String {
        "\(planet.rawValue) \(aspect.rawValue) \(natalPlanet.rawValue)"
    }
}
