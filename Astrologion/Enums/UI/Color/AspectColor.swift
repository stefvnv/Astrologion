import UIKit

public enum AspectColor: String {
    case gold = "#EAD9A4" // gold
    case blue = "#A3C1D9" // blue
    case red = "#FFA07A" // red
    case green = "#A5C9A0" // green
    case orange = "#FFE5CC" // orange

    var uiColor: UIColor {
        return UIColor(hex: self.rawValue) ?? .black
    }
}
