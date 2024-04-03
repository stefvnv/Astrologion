import Foundation

class LongitudeParser {
    static func parseLongitude(from string: String) -> Double? {
        let components = string.components(separatedBy: " ")
        guard components.count == 2,
              let zodiacSign = ZodiacSign(rawValue: components[0]),
              let degreesComponent = components.last else { return nil }

        let degreesMinutes = degreesComponent.components(separatedBy: "°")
        guard degreesMinutes.count == 2,
              let degrees = Double(degreesMinutes[0]),
              let minutes = Double(degreesMinutes[1].trimmingCharacters(in: CharacterSet(charactersIn: "'"))) else { return nil }

        let result = zodiacSign.baseDegree + degrees + minutes / 60.0
        return result
    }
}
