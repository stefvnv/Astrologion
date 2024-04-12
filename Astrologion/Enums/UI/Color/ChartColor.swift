import UIKit

public enum ChartColor {
    case navy
    case lavender
    case lilac
    case gold
    case roseQuartz
    case aquamarine
    case peach
    case sageGreen
    case midnightBlue
    case ivory

    var uiColor: UIColor {
        switch self {
        case .navy:
            return UIColor(hex: "#110730") ?? .black
        case .lavender:
            return UIColor(hex: "#BAABEB") ?? .black
        case .lilac:
            return UIColor(hex: "#E3DDF7") ?? .black
        case .gold:
            return UIColor(hex: "#B8A65F") ?? .black
        case .roseQuartz:
            return UIColor(hex: "#F7CAC9") ?? .black
        case .aquamarine:
            return UIColor(hex: "#7FDBDA") ?? .black
        case .peach:
            return UIColor(hex: "#FFE5B4") ?? .black
        case .sageGreen:
            return UIColor(hex: "#9DC183") ?? .black
        case .midnightBlue:
            return UIColor(hex: "#003366") ?? .black
        case .ivory:
            return UIColor(hex: "#FFFFF0") ?? .black
        }
    }
}
