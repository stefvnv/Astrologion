import Foundation

struct Transit: Identifiable {
    let id = UUID()
    let planet: Planet
    let sign: ZodiacSign
    let house: Int
    let aspect: Aspect
    let natalPlanet: Planet
}
