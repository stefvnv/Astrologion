import SwiftUI

public enum PolarityColor: String {
    case yin = "#1C1C2E"
    case yang = "#FAFAFC"

    var color: UIColor {
        UIColor(hex: self.rawValue) ?? .gray
    }
}
