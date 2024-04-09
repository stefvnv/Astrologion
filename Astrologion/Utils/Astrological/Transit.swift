import Foundation

struct Transit: Identifiable, Equatable {
    let id = UUID()
    let planet: Planet
    let sign: ZodiacSign
    let house: Int
    let aspects: [Aspect]
    let natalPlanet: Planet?
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
        let natalOrTransitingPlanetName = natalPlanet?.rawValue ?? planet.rawValue
        return "\(planet.rawValue) \(aspect.rawValue) \(natalOrTransitingPlanetName)"
    }


// MARK: - Equitable Conformance
    
    static func ==(lhs: Transit, rhs: Transit) -> Bool {
        lhs.id == rhs.id
    }
}
