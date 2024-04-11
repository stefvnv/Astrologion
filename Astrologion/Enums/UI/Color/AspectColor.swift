import UIKit

public enum AspectColor: String {
    case gold = "#EAD9A4" // gold
    case blue = "#A3C1D9" // blue
    case red = "#FFA07A" // red
    case green = "#A5C9A0" // green
    case orange = "#FFE5CC" // orange
    
    case darkGold = "#B58C2A" // darker gold
    case darkBlue = "#51788D" // darker blue
    case darkRed = "#BF5640" // darker red
    case darkGreen = "#527F4F" // darker green
    case darkOrange = "#B07B46" // darker orange

    var uiColor: UIColor {
        return UIColor(hex: self.rawValue) ?? .black
    }
}
