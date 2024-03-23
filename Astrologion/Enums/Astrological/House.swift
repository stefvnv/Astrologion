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
}

///
extension House {
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
}
