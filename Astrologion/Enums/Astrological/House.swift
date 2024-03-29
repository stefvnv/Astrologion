/// Represents the twelve astrological houses, each with a unique name and position in the horoscope chart
public enum House: Int, CaseIterable {
    case first = 1, second, third, fourth, fifth, sixth,
         seventh, eighth, ninth, tenth, eleventh, twelfth
    
    /// The name of the astrological house, with special designations for the first (ASC) and tenth (MC) houses
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
    
    /// Roman numeral representation of the house number
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
    
    /// The formatted house name with ordinal suffixes, e.g., "1st House", "2nd House"
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
}
