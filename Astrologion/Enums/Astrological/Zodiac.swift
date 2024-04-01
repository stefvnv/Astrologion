/// Represents the twelve signs of the Zodiac, each with associated symbols and order in the zodiacal cycle
public enum Zodiac: String, CaseIterable {
    case Aries = "Aries"
    case Taurus = "Taurus"
    case Gemini = "Gemini"
    case Cancer = "Cancer"
    case Leo = "Leo"
    case Virgo = "Virgo"
    case Libra = "Libra"
    case Scorpio = "Scorpio"
    case Sagittarius = "Sagittarius"
    case Capricorn = "Capricorn"
    case Aquarius = "Aquarius"
    case Pisces = "Pisces"
    
    /// ordinal position of the Zodiac sign within the zodiacal cycle, starting from Aries as 0
    var order: Int {
        return Zodiac.allCases.firstIndex(of: self) ?? 0
    }
    
    /// astrological symbol associated with the Zodiac sign
    var symbol: String {
        switch self {
        case .Aries: return "♈︎"
        case .Taurus: return "♉︎"
        case .Gemini: return "♊︎"
        case .Cancer: return "♋︎"
        case .Leo: return "♌︎"
        case .Virgo: return "♍︎"
        case .Libra: return "♎︎"
        case .Scorpio: return "♏︎"
        case .Sagittarius: return "♐︎"
        case .Capricorn: return "♑︎"
        case .Aquarius: return "♒︎"
        case .Pisces: return "♓︎"
        }
    }

    /// base degree associated with the Zodiac sign
    var baseDegree: Double {
        switch self {
        case .Aries: return 0
        case .Taurus: return 30
        case .Gemini: return 60
        case .Cancer: return 90
        case .Leo: return 120
        case .Virgo: return 150
        case .Libra: return 180
        case .Scorpio: return 210
        case .Sagittarius: return 240
        case .Capricorn: return 270
        case .Aquarius: return 300
        case .Pisces: return 330
        }
    }
    
    var element: Element {
        switch self {
        case .Aries, .Leo, .Sagittarius: return .fire
        case .Taurus, .Virgo, .Capricorn: return .earth
        case .Gemini, .Libra, .Aquarius: return .air
        case .Cancer, .Scorpio, .Pisces: return .water
        }
    }

    var modality: Modality {
        switch self {
        case .Aries, .Cancer, .Libra, .Capricorn: return .cardinal
        case .Taurus, .Leo, .Scorpio, .Aquarius: return .fixed
        case .Gemini, .Virgo, .Sagittarius, .Pisces: return .mutable
        }
    }

    var polarity: Polarity {
        switch self {
        case .Aries, .Gemini, .Leo, .Libra, .Sagittarius, .Aquarius: return .yang
        case .Taurus, .Cancer, .Virgo, .Scorpio, .Capricorn, .Pisces: return .yin
        }
    }

    var ruler: Ruler {
        switch self {
        case .Aries: return .mars
        case .Taurus, .Libra: return .venus
        case .Gemini, .Virgo: return .mercury
        case .Cancer: return .moon
        case .Leo: return .sun
        case .Scorpio: return .pluto
        case .Sagittarius: return .jupiter
        case .Capricorn: return .saturn
        case .Aquarius: return .uranus
        case .Pisces: return .neptune
        }
    }
    
    // MARK: - Planet Expanded View
    
    var image: String {
        return self.rawValue.lowercased()
    }

    ///
    func description(for planet: Planet) -> String {
        let placements = loadAstrologicalData()

        if let placement = placements.first(where: { $0.planet == planet.rawValue && $0.sign == self.rawValue }) {
            return placement.description
        } else {
            return "No description available for \(planet.rawValue) in \(self.rawValue)."
        }
    }
}
