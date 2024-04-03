import SwiftUI

enum TransitTab: String, CaseIterable {
    case overview, sun, moon, mercury, venus, mars, jupiter, saturn, uranus, neptune, pluto

    var title: String {
        switch self {
            default: return rawValue.capitalized
        }
    }
}
