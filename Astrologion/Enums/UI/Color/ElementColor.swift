import UIKit
import SwiftUI

public enum ElementColor: String {
    case red = "#E6A8A1"
    case green = "#A8C0BB" 
    case yellow = "#F3E0AC"
    case blue = "#AFC9E9"

    var uiColor: UIColor {
        return UIColor(hex: self.rawValue) ?? .black
    }
    
    var color: SwiftUI.Color {
        SwiftUI.Color(uiColor: self.uiColor)
    }
}
