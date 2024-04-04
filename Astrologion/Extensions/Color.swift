import SwiftUI

extension Color {
    static var theme = CustomTheme.self

    init(hex: Int, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}

extension UIColor {
    convenience init?(hex: String) {
        let hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt32 = 0

        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }

        let red, green, blue, alpha: CGFloat
        switch hexSanitized.count {
        case 3: // RGB (12-bit)
            red = CGFloat((rgb & 0xF00) >> 8) / 15.0
            green = CGFloat((rgb & 0x0F0) >> 4) / 15.0
            blue = CGFloat(rgb & 0x00F) / 15.0
            alpha = 1.0
        case 6, 8: // RGB (24-bit) or ARGB (32-bit)
            alpha = hexSanitized.count == 8 ? CGFloat((rgb & 0xFF000000) >> 24) / 255.0 : 1.0
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0
        default:
            return nil
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

struct Theme {
    let systemBackground = Color("SystemBackgroundColor")
}
