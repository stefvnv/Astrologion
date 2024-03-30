import SwiftUI

public enum Polarity: String, CaseIterable {
    case yin = "Yin"
    case yang = "Yang"
    
    var symbol: Image {
        switch self {
        case .yin: return Image("yin")
        case .yang: return Image("yang")
        }
    }
    
    var color: UIColor {
        switch self {
        case .yin: return PolarityColor.yin.color
        case .yang: return PolarityColor.yang.color
        }
    }
}
