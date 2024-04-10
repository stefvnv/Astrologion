import SwiftUI

struct TopRoundedRectangle: Shape {
    var radii: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radii))
        path.addArc(center: CGPoint(x: rect.minX + radii, y: rect.minY + radii), radius: radii, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX - radii, y: rect.minY))
        path.addArc(center: CGPoint(x: rect.maxX - radii, y: rect.minY + radii), radius: radii, startAngle: Angle(degrees: 270), endAngle: Angle(degrees: 0), clockwise: false)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))

        return path
    }
}
