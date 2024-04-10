import Foundation

class AstrologicalCalculations {
    static func calculatePositionForPlanet(_ planet: Planet, at longitude: Double, usingAscendant ascendant: Double, in rect: CGRect) -> CGPoint {
        let ascendantOffset = 180.0 - ascendant
        let adjustedLongitude = longitude + ascendantOffset
        let angle = (360 - (adjustedLongitude.truncatingRemainder(dividingBy: 360))).truncatingRemainder(dividingBy: 360)
        let radians = angle.degreesToRadians
        
        let outerRadius = min(rect.size.width, rect.size.height) / 2
        let planetRadius = (outerRadius + outerRadius * 0.8) / 2.5
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let x = center.x + planetRadius * cos(radians)
        let y = center.y + planetRadius * sin(radians)
        
        return CGPoint(x: x, y: y)
    }
    
    
    static func calculatePositionForPoint(at longitude: Double, usingAscendant ascendant: Double, in rect: CGRect) -> CGPoint {
        let ascendantOffset = 180.0 - ascendant
        let adjustedLongitude = longitude + ascendantOffset
        let angle = (360 - (adjustedLongitude.truncatingRemainder(dividingBy: 360))).truncatingRemainder(dividingBy: 360)
        let radians = angle.degreesToRadians
        
        let outerRadius = min(rect.size.width, rect.size.height) / 2
        let pointRadius = (outerRadius + outerRadius * 0.8) / 2
        
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let x = center.x + pointRadius * cos(radians)
        let y = center.y + pointRadius * sin(radians)
        
        return CGPoint(x: x, y: y)
    }
    
}
