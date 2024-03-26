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
        do {
            try await calculateAstrologicalDetails(
                day: day, month: month, year: year,
                hour: hour, minute: minute,
                latitude: latitude, longitude: longitude,
                houseSystem: houseSystem
            )
        } catch {
            print("An error occurred: \(error)")
        }
    }

    
    ///
    public func calculateAstrologicalDetails(
        day: Int, month: Int, year: Int,
        hour: Int, minute: Int,
        latitude: Double, longitude: Double,
        houseSystem: HouseSystem
    ) async throws {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        guard let timeZone = placemarks.first?.timeZone else {
            throw GeocoderError.timezoneError
        }
        
        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.timeZone = timeZone

        guard let date = Calendar.current.date(from: dateComponents) else {
            throw GeocoderError.dateConversionError
        }
        
        let isDST = timeZone.isDaylightSavingTime(for: date)
        let dstOffset = isDST ? timeZone.daylightSavingTimeOffset(for: date) : 0
        let jd = swe_julday(Int32(year), Int32(month), Int32(day), Double(hour) + Double(minute) / 60.0 - Double(dstOffset) / 3600.0, SE_GREG_CAL)

        calculatePlanetaryPositions(julianDay: jd)
        calculateHouseCusps(julianDay: jd, latitude: latitude, longitude: longitude, houseSystem: houseSystem.rawValue)
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
        var cusps = [Double](repeating: 0.0, count: 13) // array for cusps
        var ascmc = [Double](repeating: 0.0, count: 10) // array for special points

        // call SE function to calculate house cusps
        swe_houses(jd, latitude, longitude, houseSystem, &cusps, &ascmc)

        // update published properties
        DispatchQueue.main.async {
            
            print("DISPATCH SECTION INSIDE CALCULATE HOUSE CUSPS!!!!")
            
            self.houseCusps = Array(cusps[1...12]) // set house cusps
            self.ascendant = ascmc[0] // ascendant
            self.midheavenLongitude = ascmc[1] // midheaven
        }
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

