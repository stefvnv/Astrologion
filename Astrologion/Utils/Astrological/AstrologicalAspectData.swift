struct AstrologicalAspectData: Hashable {
    let planet1: Planet
    let planet2: Planet
    let aspect: Aspect
    let exactAngle: Double
    let orb: Double
}
