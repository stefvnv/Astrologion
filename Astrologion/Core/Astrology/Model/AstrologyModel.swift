import Foundation
import SwissEphemeris
import CoreLocation

public class AstrologyModel: ObservableObject {
    @Published var planetaryPositions: [Point: Double] = [:]
    @Published var houseCusps: [Double] = Array(repeating: 0.0, count: 12)
    @Published var ascendant: Double = 0.0
    @Published var midheavenLongitude: Double = 0.0
    
    var sunPosition: String = ""
    var moonPosition: String = ""


    ///
    public func initializeEphemeris() {
        let ephemerisPath = Bundle.main.path(forResource: "ephe", ofType: nil) ?? ""
        var cEphemerisPath = ephemerisPath.cString(using: .utf8)
        swe_set_ephe_path(&cEphemerisPath)
    }
    
    
    ///
    public func populateAndCalculate(
        day: Int, month: Int, year: Int,
        hour: Int, minute: Int,
        latitude: Double, longitude: Double,
        houseSystem: HouseSystem = .placidus
    ) async {
        await calculateAstrologicalDetails(
            day: day, month: month, year: year,
            hour: hour, minute: minute,
            latitude: latitude, longitude: longitude,
            houseSystem: houseSystem
        )
    }

    
    ///
    public func calculateAstrologicalDetails(
        day: Int, month: Int, year: Int,
        hour: Int, minute: Int,
        latitude: Double, longitude: Double,
        houseSystem: HouseSystem
    ) async {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let timeZone = placemarks.first?.timeZone else {
                return
            }

            var dateComponents = DateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = day
            dateComponents.hour = hour
            dateComponents.minute = minute
            dateComponents.timeZone = timeZone

            if let date = Calendar.current.date(from: dateComponents) {
                let isDST = timeZone.isDaylightSavingTime(for: date)
                let dstOffset = isDST ? timeZone.daylightSavingTimeOffset(for: date) : 0
                let jd = swe_julday(Int32(year), Int32(month), Int32(day), Double(hour) + Double(minute) / 60.0 - Double(dstOffset) / 3600.0, SE_GREG_CAL)

                calculatePlanetaryPositions(julianDay: jd)
                calculateHouseCusps(julianDay: jd, latitude: latitude, longitude: longitude, houseSystem: houseSystem.rawValue)
            }
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    ///
    private func calculatePlanetaryPositions(julianDay jd: Double) {
        Point.allCases.forEach { point in
            var xx = [Double](repeating: 0, count: 6)
            var serr = [Int8](repeating: 0, count: 256)
            
            let result = swe_calc_ut(jd, point.rawValue, SEFLG_SWIEPH, &xx, &serr)
            if result >= 0 { // Check if calculation was successful
                planetaryPositions[point] = xx[0]
            } else {
                print("Error calculating position for \(point): \(String(cString: serr))")
            }
        }
    }

    
    ///
    private func calculateHouseCusps(julianDay jd: Double, latitude: Double, longitude: Double, houseSystem: Int32) {
        var cusps = [Double](repeating: 0.0, count: 13)
        var ascmc = [Double](repeating: 0.0, count: 10)

        let result = swe_houses(jd, latitude, longitude, houseSystem, &cusps, &ascmc)
        if result == 0 {
            DispatchQueue.main.async {
                self.houseCusps = Array(cusps[1...12])
                self.ascendant = ascmc[0]
                self.midheavenLongitude = cusps[10]
            }
        } else {
            print("Error calculating house cusps")
        }
    }

    
    ///
    private func performCalculations(
        withTimeZone timeZone: TimeZone,
        day: Int, month: Int, year: Int,
        hour: Int, minute: Int,
        latitude: Double, longitude: Double, houseSystem: Int32,
        completion: @escaping () -> Void
    ) {
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.timeZone = timeZone

        guard let date = Calendar.current.date(from: dateComponents) else {
            print("Date conversion error")
            completion()
            return
        }

        let isDST = timeZone.isDaylightSavingTime(for: date)
        let dstOffset = isDST ? timeZone.daylightSavingTimeOffset(for: date) : 0
        let jd = swe_julday(Int32(year), Int32(month), Int32(day), Double(hour) + Double(minute) / 60.0 - Double(dstOffset) / 3600.0, SE_GREG_CAL)

        calculatePlanetaryPositions(julianDay: jd)
        calculateHouseCusps(julianDay: jd, latitude: latitude, longitude: longitude, houseSystem: houseSystem)
        completion()
    }
    
    
//    // TO BE DELETED (converted to table)
//    func printHouseCusps() {
//        guard houseCusps.count == 12 else {
//            print("Error: Expected 12 house cusps but found \(houseCusps.count)")
//            return
//        }
//
//        for (index, cusp) in houseCusps.enumerated() {
//            if let house = House(rawValue: index + 1) {
//                let signAndDegree = zodiacSignAndDegree(fromLongitude: cusp)
//                print("\(house.name)\t\t\(signAndDegree)")
//            }
//        }
//    }
    
    
    ///
    func calculateAspects() -> [AstrologicalAspectData] {
        var aspects: [AstrologicalAspectData] = []

        let planetSet = Set(planetaryPositions.keys) // Convert keys to a set
        let planetPairs = combinations(planetSet) // Use the set here

        for (planet1, planet2) in planetPairs {
            guard let longitude1 = planetaryPositions[planet1], let longitude2 = planetaryPositions[planet2] else { continue }

            let angleDifference = min(abs(longitude1 - longitude2), 360 - abs(longitude1 - longitude2))

            for aspect in Aspect.allCases {
                if abs(angleDifference - aspect.angle) <= aspect.orb {
                    let aspectData = AstrologicalAspectData(planet1: planet1, planet2: planet2, aspect: aspect, angleDifference: angleDifference)
                    aspects.append(aspectData)
                }
            }
        }

        return aspects
    }


    

    private func combinations<T>(_ elements: Set<T>) -> [(T, T)] {
        var result: [(T, T)] = []
        let array = Array(elements)

        for i in 0..<array.count {
            for j in (i + 1)..<array.count {
                result.append((array[i], array[j]))
            }
        }
        return result
    }


    
} // end


struct AstrologicalAspectData {
    let planet1: Point
    let planet2: Point
    let aspect: Aspect
    let angleDifference: Double
    
    init(planet1: Point, planet2: Point, aspect: Aspect, angleDifference: Double) {
        self.planet1 = planet1
        self.planet2 = planet2
        self.aspect = aspect
        self.angleDifference = angleDifference
    }
}


struct PlanetPosition {
    var planet: Point
    var position: CGPoint
    var longitude: CGFloat
}

