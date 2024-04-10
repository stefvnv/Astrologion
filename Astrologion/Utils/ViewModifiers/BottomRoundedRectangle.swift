import SwiftUI

struct BottomRoundedRectangle: Shape {
    var radii: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - radii))
        path.addArc(center: CGPoint(x: rect.minX + radii, y: rect.maxY - radii), radius: radii, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 90), clockwise: true)
        path.addLine(to: CGPoint(x: rect.maxX - radii, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.maxX - radii, y: rect.maxY - radii), radius: radii, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 0), clockwise: true)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

        return path
    }
}
