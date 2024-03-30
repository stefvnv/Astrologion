import SwiftUI

public enum Modality: String, CaseIterable {
    case cardinal = "Cardinal"
    case fixed = "Fixed"
    case mutable = "Mutable"

    var symbol: Image {
        switch self {
        case .cardinal: return Image("cardinal")
        case .fixed: return Image("fixed")
        case .mutable: return Image("mutable")
        }
    }

    var color: UIColor {
        switch self {
        case .cardinal: return ModalityColor.cardinal.color
        case .fixed: return ModalityColor.fixed.color
        case .mutable: return ModalityColor.mutable.color
        }
    }
}
