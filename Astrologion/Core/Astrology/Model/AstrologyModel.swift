import Foundation
import SwissEphemeris
import CoreLocation


public class AstrologyModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var planetPositions = [Planet: (position: String, longitude: Double)]()
    @Published var houseCusps: [Double] = Array(repeating: 0.0, count: 12)
    @Published var ascendant: Double = 0.0
    @Published var midheavenLongitude: Double = 0.0
    
    
    // MARK: - Private Properties
    private let planets = Planet.allCases

    
    // MARK: - Initialization
    public func initializeEphemeris() {
        let ephemerisPath = Bundle.main.path(forResource: "ephe", ofType: nil) ?? ""
        var cEphemerisPath = ephemerisPath.cString(using: .utf8)
        swe_set_ephe_path(&cEphemerisPath)
    }
    
    
    // MARK: - Astrological Calculations
    var astrologicalPlanetaryPositions: [(body: Planet, longitude: Double)] {
        var positions: [(body: Planet, longitude: Double)] = []

        positions.append((body: .Sun, longitude: planetPositions[.Sun]?.longitude ?? 0.0))
        positions.append((body: .Moon, longitude: planetPositions[.Moon]?.longitude ?? 0.0))
        positions.append((body: .Mercury, longitude: planetPositions[.Mercury]?.longitude ?? 0.0))
        positions.append((body: .Venus, longitude: planetPositions[.Venus]?.longitude ?? 0.0))
        positions.append((body: .Mars, longitude: planetPositions[.Mars]?.longitude ?? 0.0))
        positions.append((body: .Jupiter, longitude: planetPositions[.Jupiter]?.longitude ?? 0.0))
        positions.append((body: .Saturn, longitude: planetPositions[.Saturn]?.longitude ?? 0.0))
        positions.append((body: .Uranus, longitude: planetPositions[.Uranus]?.longitude ?? 0.0))
        positions.append((body: .Neptune, longitude: planetPositions[.Neptune]?.longitude ?? 0.0))
        positions.append((body: .Pluto, longitude: planetPositions[.Pluto]?.longitude ?? 0.0))
        positions.append((body: .Lilith, longitude: planetPositions[.Lilith]?.longitude ?? 0.0))
        positions.append((body: .NorthNode, longitude: planetPositions[.NorthNode]?.longitude ?? 0.0))

        positions.append((body: .Ascendant, longitude: ascendant))
        positions.append((body: .Midheaven, longitude: midheavenLongitude))

        return positions
    }
    
    public func calculateAstrologicalDetails(day: Int, month: Int, year: Int, hour: Int, minute: Int, latitude: Double, longitude: Double, houseSystem: HouseSystem) async throws {
        let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
        let date = try Calendar.current.date(from: dateComponents).unwrap()
        let timeZone = try await determineTimeZone(for: latitude, longitude, date: date)
        let jd = calculateJulianDay(year: year, month: month, day: day, hour: hour, minute: minute, date: date, timeZone: timeZone)
        
        calculatePlanetaryPositions(julianDay: jd)
        calculateHouseCusps(julianDay: jd, latitude: latitude, longitude: longitude, houseSystem: houseSystem.rawValue)
    }

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

        if let date = Calendar.current.date(from: dateComponents) {
            let isDST = timeZone.isDaylightSavingTime(for: date)
            let dstOffset = isDST ? timeZone.daylightSavingTimeOffset(for: date) : 0
            let jd = swe_julday(Int32(year), Int32(month), Int32(day), Double(hour) + Double(minute) / 60.0 - Double(dstOffset) / 3600.0, SE_GREG_CAL)

            self.calculatePlanetaryPositions(julianDay: jd)
            self.calculateHouseCusps(julianDay: jd, latitude: latitude, longitude: longitude, houseSystem: houseSystem)
        }
        completion()
    }
    
    private func calculatePlanetaryPositions(julianDay jd: Double) {
        for planet in planets {
            let (position, longitude) = calculatePositionAndLongitude(for: planet, julianDay: jd)
            DispatchQueue.main.async {
                self.planetPositions[planet] = (position, longitude)
            }
        }
    }
    
    private func calculatePositionAndLongitude(for planet: Planet, julianDay jd: Double) -> (String, Double) {
        guard let seIdentifier = planet.seIdentifier else {
            print("No SE identifier for \(planet.rawValue). Using default longitude.")
            return ("Invalid", 0.0)
        }

        var xx = [Double](repeating: 0, count: 6)
        var serr = [Int8](repeating: 0, count: 256)

        swe_calc_ut(jd, seIdentifier, SEFLG_SWIEPH, &xx, &serr)
        let longitude = xx[0]
        let position = zodiacSignAndDegree(fromLongitude: longitude)

        return (position, longitude)
    }

    private func calculateHouseCusps(julianDay jd: Double, latitude: Double, longitude: Double, houseSystem: Int32) {
        var cusps = [Double](repeating: 0.0, count: 13)
        var ascmc = [Double](repeating: 0.0, count: 10)

        swe_houses(jd, latitude, longitude, houseSystem, &cusps, &ascmc)

        DispatchQueue.main.async {
            self.houseCusps = Array(cusps[1...12])
            self.ascendant = ascmc[0]
            self.midheavenLongitude = ascmc[1]
            
            // TO BE DELETED
            self.printHouseCusps()
        }
    }
    
    // TO BE DELETED
    func printHouseCusps() {
        guard houseCusps.count == 12 else {
            print("Error: Expected 12 house cusps but found \(houseCusps.count)")
            return
        }

        for (index, cusp) in houseCusps.enumerated() {
            if let house = House(rawValue: index + 1) {
                let signAndDegree = zodiacSignAndDegree(fromLongitude: cusp)
                print("\(house.name)\t\t\(signAndDegree)")
            }
        }
    }
    
    private func zodiacSignAndDegree(fromLongitude longitude: Double) -> String {
        let signIndex = Int(longitude / 30) % ZodiacSign.allCases.count
        let zodiacSign = ZodiacSign.allCases[signIndex]

        let degreeComponent = longitude.truncatingRemainder(dividingBy: 30)
        let degrees = Int(degreeComponent)
        let minutes = Int((degreeComponent - Double(degrees)) * 60)

        return "\(zodiacSign.rawValue) \(degrees)°\(minutes)'"
    }
    
    private func determineTimeZone(for latitude: Double, _ longitude: Double, date: Date) async throws -> TimeZone {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let placemarks = try await CLGeocoder().reverseGeocodeLocation(location)
        guard let timeZone = placemarks.first?.timeZone else {
            throw CustomError.timezoneError
        }
        return timeZone
    }

    private func calculateJulianDay(year: Int, month: Int, day: Int, hour: Int, minute: Int, date: Date, timeZone: TimeZone) -> Double {
        let isDST = timeZone.isDaylightSavingTime(for: date)
        let dstOffset = isDST ? timeZone.daylightSavingTimeOffset(for: date) : 0
        return swe_julday(Int32(year), Int32(month), Int32(day), Double(hour) + Double(minute) / 60.0 - Double(dstOffset) / 3600.0, SE_GREG_CAL)
    }

    func calculateAspects() -> [AstrologicalAspectData] {
        var aspects: [AstrologicalAspectData] = []
        
        for i in 0..<astrologicalPlanetaryPositions.count {
            for j in (i + 1)..<astrologicalPlanetaryPositions.count {
                let (planet1, longitude1) = astrologicalPlanetaryPositions[i]
                let (planet2, longitude2) = astrologicalPlanetaryPositions[j]
                let angleDifference = abs(longitude1 - longitude2)
                let normalizedAngle = min(angleDifference, 360 - angleDifference)
                
                for aspect in Aspect.allCases {
                    if normalizedAngle >= aspect.angle - aspect.orb && normalizedAngle <= aspect.angle + aspect.orb {
                        let exactAngle = normalizedAngle
                        let aspectOrb = abs(normalizedAngle - aspect.angle)

                        let aspectData = AstrologicalAspectData(planet1: planet1, planet2: planet2, aspect: aspect, exactAngle: exactAngle, orb: aspectOrb)
                        aspects.append(aspectData)
                        
                        // TO BE DELETED
                        print("Aspect: \(aspect) between \(planet1) and \(planet2), Angle Difference: \(normalizedAngle), Orb: \(aspectOrb)")

                    }
                }
            }
        }
        return aspects
    }
    
    private func calculatePlanetPosition(planet: Planet, julianDay jd: Double) {
        guard let seIdentifier = planet.seIdentifier else {
            print("No SE identifier for \(planet.rawValue).")
            return
        }

        var xx = [Double](repeating: 0, count: 6)
        var serr = [Int8](repeating: 0, count: 256)
        swe_calc_ut(jd, seIdentifier, SEFLG_SWIEPH, &xx, &serr)
        let longitude = xx[0]
        let position = zodiacSignAndDegree(fromLongitude: longitude)

        DispatchQueue.main.async {
            self.planetPositions[planet] = (position, longitude)
        }
    }
    
    private func updateAstrologicalBodyPosition(julianDay jd: Double, planet: Int32, updateLongitude longitude: inout Double, updatePosition position: inout String) {
        var xx = [Double](repeating: 0, count: 6)
        var serr = [Int8](repeating: 0, count: 256)
        
        swe_calc_ut(jd, planet, SEFLG_SWIEPH, &xx, &serr)
        longitude = xx[0]
        position = zodiacSignAndDegree(fromLongitude: xx[0])
        
        var nameBuffer = [Int8](repeating: 0, count: 30)  // Assuming name will not exceed 29 characters
        swe_get_planet_name(planet, &nameBuffer)
        let planetName = String(cString: nameBuffer)
        
        // TO BE DELETED: console test
        print("\(planetName) Position: \(position) at \(longitude) degrees")
        
    }
    

    func determineHouse(for longitude: Double, usingCusps cusps: [Double]) -> Int {
        print("Determining house for longitude: \(longitude)")
        print("Using cusps: \(cusps)")
        for (index, cusp) in cusps.enumerated() {
            if index == 0 && longitude < cusps.first! {
                print("Longitude \(longitude) is in the 12th house")
                return 12 // The last house
            }
            if index < cusps.count - 1 && longitude >= cusp && longitude < cusps[index + 1] {
                print("Longitude \(longitude) is in house \(index + 1)")
                return index + 1
            }
        }
        print("Longitude \(longitude) is in the 12th house by default")
        return 12 // Default to the last house if not found
    }


    
    
    // MARK: - Chart conversion
    
    func toChart(userId: String) -> Chart {
        
        // convert planetary longitudes to zodiac sign and degree strings
        let planetaryPositions = self.astrologicalPlanetaryPositions.reduce(into: [String: String]()) { (dict, tuple) in
            let (body, longitude) = tuple
            dict[body.rawValue] = self.zodiacSignAndDegree(fromLongitude: longitude)
        }
        
        // convert house cusp longitudes to zodiac sign and degree strings
        let houseCuspsDict = self.houseCusps.enumerated().reduce(into: [String: String]()) { (dict, tuple) in
            let (index, cusp) = tuple
            dict["House \(index + 1)"] = self.zodiacSignAndDegree(fromLongitude: cusp)
        }
        
        // format aspects into strings
        let aspectDescriptions = self.calculateAspects().map { aspectData -> String in
            let planet1Name = aspectData.planet1.rawValue
            let planet2Name = aspectData.planet2.rawValue
            let aspectName = aspectData.aspect.description
            let exactAngle = String(format: "%.2f", aspectData.exactAngle)
            let orb = String(format: "%.2f", aspectData.orb)
            return "\(planet1Name) \(aspectName) \(planet2Name) at \(exactAngle)° with orb of \(orb)°"
        }
        
        // create chart object
        let chart = Chart(
            userId: userId,
            planetaryPositions: planetaryPositions,
            houseCusps: houseCuspsDict,
            aspects: aspectDescriptions
        )
        
        print("Converted Chart: \(chart)")
        return chart
    }

    
} // end

// MARK: - Extensions
private extension Optional {
    func unwrap() throws -> Wrapped {
        guard let unwrapped = self else {
            throw CustomError.unwrappedError
        }
        return unwrapped
    }
}
