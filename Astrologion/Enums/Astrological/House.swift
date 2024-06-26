/// Represents the twelve astrological houses, each with a unique name and position in the horoscope chart
public enum House: Int, CaseIterable {
    case first = 1, second, third, fourth, fifth, sixth,
         seventh, eighth, ninth, tenth, eleventh, twelfth
    
    var name: String {
        switch self {
        case .first: return "I ASC"
        case .second: return "II"
        case .third: return "III"
        case .fourth: return "IV"
        case .fifth: return "V"
        case .sixth: return "VI"
        case .seventh: return "VII"
        case .eighth: return "VIII"
        case .ninth: return "IX"
        case .tenth: return "X MC"
        case .eleventh: return "XI"
        case .twelfth: return "XII"
        }
    }
    
    var romanNumeral: String {
        switch self {
        case .first: return "I"
        case .second: return "II"
        case .third: return "III"
        case .fourth: return "IV"
        case .fifth: return "V"
        case .sixth: return "VI"
        case .seventh: return "VII"
        case .eighth: return "VIII"
        case .ninth: return "IX"
        case .tenth: return "X"
        case .eleventh: return "XI"
        case .twelfth: return "XII"
        }
    }
    
    var keyword: String {
        switch self {
        case .first: return "Self"
        case .second: return "Values"
        case .third: return "Communications"
        case .fourth: return "Home"
        case .fifth: return "Pleasure"
        case .sixth: return "Health"
        case .seventh: return "Partnership"
        case .eighth: return "Transformation"
        case .ninth: return "Purpose"
        case .tenth: return "Social Status"
        case .eleventh: return "Friendships"
        case .twelfth: return "Subconscious"
        }
    }
    
    var imageName: String {
        switch self {
        case .first: return "first-house"
        case .second: return "second-house"
        case .third: return "third-house"
        case .fourth: return "fourth-house"
        case .fifth: return "fifth-house"
        case .sixth: return "sixth-house"
        case .seventh: return "seventh-house"
        case .eighth: return "eighth-house"
        case .ninth: return "ninth-house"
        case .tenth: return "tenth-house"
        case .eleventh: return "eleventh-house"
        case .twelfth: return "twelfth-house"
        }
    }
    
    var shortHouseFormat: String {
        "\(self.rawValue)H"
    }
    
    var formattedName: String {
        let suffix: String
        switch self.rawValue {
        case 1, 21, 31: suffix = "st"
        case 2, 22: suffix = "nd"
        case 3, 23: suffix = "rd"
        default: suffix = "th"
        }
        return "\(self.rawValue)\(suffix) House"
    }
    
    
    
    var numericalFormattedName: String {
        let suffix: String
        switch self.rawValue {
        case 1: suffix = "st"
        case 2: suffix = "nd"
        case 3: suffix = "rd"
        default: suffix = "th"
        }
        return "\(self.rawValue)\(suffix)"
    }

    
    
    
    // MARK: - House Expanded View
    
    var image: String {
        return "\(self.rawValue)-house"
    }
    
    func description(for planet: Planet, house: House) -> String {
        let houseDescriptions = loadAstrologicalHouseData()

        if let description = houseDescriptions.first(where: { $0.planet == planet.rawValue && $0.house == house.numericalFormattedName }) {
            return description.description
        } else {
            return "No description available for \(planet.rawValue) in the \(house.numericalFormattedName)."
        }
    }



    func cuspDescription(forSign sign: String) -> String {
        let houseDescriptions = loadHouseCuspData()
        
        if let description = houseDescriptions.first(where: { $0.house == self.rawValue && $0.sign.caseInsensitiveCompare(sign) == .orderedSame }) {
            return description.description
        } else {
            return "No description available for the \(self.formattedName) in \(sign)."
        }
    }
}
