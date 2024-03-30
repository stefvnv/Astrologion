import SwiftUI

public enum Element: String, CaseIterable {
    case fire = "Fire"
    case earth = "Earth"
    case air = "Air"
    case water = "Water"

    var symbol: Image {
        switch self {
        case .fire: return Image("fire")
        case .earth: return Image("earth")
        case .air: return Image("air")
        case .water: return Image("water")
        }
    }

    var color: ElementColor {
        switch self {
        case .fire: return .red
        case .earth: return .green
        case .air: return .yellow
        case .water: return .blue
        }
    }
}
