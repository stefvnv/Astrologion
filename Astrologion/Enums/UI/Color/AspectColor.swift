import UIKit

public enum AspectColor: String {
    case lightGreen = "#9BCB9B" // Muted Light Green
    case darkGreen = "#8FBC8F" // Muted Dark Green
    case pink = "#F4C2C2" // Muted Pink
    case red = "#FF6347" // Muted Red
    case orange = "#FFDAB9" // Muted Orange

    var uiColor: UIColor {
        return UIColor(hex: self.rawValue) ?? .black
    }
}
