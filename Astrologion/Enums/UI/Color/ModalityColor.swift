import SwiftUI

public enum ModalityColor: String {
    case cardinal = "#9E9EAF"
    case fixed = "#8E8E9F"
    case mutable = "#AFAFCF"

    var color: UIColor {
        UIColor(hex: self.rawValue) ?? .gray
    }
}
