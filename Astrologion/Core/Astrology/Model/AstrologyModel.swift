import Foundation
import SwissEphemeris
import CoreLocation

public class AstrologyModel: ObservableObject {
    
    // Planets
    @Published var sunPosition: String = "Calculating..."
    @Published var sunLongitude: Double = 0.0
    
    @Published var moonPosition: String = "Calculating..."
    @Published var moonLongitude: Double = 0.0
    
    @Published var mercuryPosition: String = "Calculating..."
    @Published var mercuryLongitude: Double = 0.0
    
    @Published var venusPosition: String = "Calculating..."
    @Published var venusLongitude: Double = 0.0
    
    @Published var marsPosition: String = "Calculating..."
    @Published var marsLongitude: Double = 0.0
    
    @Published var jupiterPosition: String = "Calculating..."
    @Published var jupiterLongitude: Double = 0.0
    
    @Published var saturnPosition: String = "Calculating..."
    @Published var saturnLongitude: Double = 0.0
    
    @Published var uranusPosition: String = "Calculating..."
    @Published var uranusLongitude: Double = 0.0
    
    @Published var neptunePosition: String = "Calculating..."
    @Published var neptuneLongitude: Double = 0.0
    
    @Published var plutoPosition: String = "Calculating..."
    @Published var plutoLongitude: Double = 0.0
    
    // Special points
    @Published var lilithPosition: String = "Calculating..."
    @Published var lilithLongitude: Double = 0.0
    
    @Published var northNodePosition: String = "Calculating..."
    @Published var northNodeLongitude: Double = 0.0
    
    // Houses
    @Published var houseCusps: [Double] = Array(repeating: 0.0, count: 12)
    @Published var ascendant: Double = 0.0
    
    // TO DO
    @Published var midheavenPosition: String = "Calculating..."
    @Published var midheavenLongitude: Double = 0.0


    
    var astrologicalPointPositions: [(body: Point, longitude: Double)] {
        var positions: [(body: Point, longitude: Double)] = [
            (body: .Sun, longitude: sunLongitude),
            (body: .Moon, longitude: moonLongitude),
            (body: .Mercury, longitude: mercuryLongitude),
            (body: .Venus, longitude: venusLongitude),
            (body: .Mars, longitude: marsLongitude),
            (body: .Jupiter, longitude: jupiterLongitude),
            (body: .Saturn, longitude: saturnLongitude),
            (body: .Uranus, longitude: uranusLongitude),
            (body: .Neptune, longitude: neptuneLongitude),
            (body: .Pluto, longitude: plutoLongitude),
            (body: .Lilith, longitude: lilithLongitude),
            (body: .NorthNode, longitude: northNodeLongitude)
        ]
        positions.append((body: .Ascendant, longitude: ascendant))
        positions.append((body: .Midheaven, longitude: midheavenLongitude))

        return positions
    }


    ///
    public func initializeEphemeris() {
        let ephemerisPath = Bundle.main.path(forResource: "ephe", ofType: nil) ?? ""
        var cEphemerisPath = ephemerisPath.cString(using: .utf8)
        swe_set_ephe_path(&cEphemerisPath)
    }
    
    
    public func calculateAstrologicalDetails(
        day: Int, month: Int, year: Int, hour: Int, minute: Int,
        latitude: Double, longitude: Double, houseSystem: HouseSystem,
        completion: @escaping () -> Void
    ) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.sunPosition = "Error: \(error.localizedDescription)"
                    completion()
                    return
                }
                
                guard let self = self, let timeZone = placemarks?.first?.timeZone else {
                    self?.sunPosition = "Timezone error"
                    completion()
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

                    self.calculatePlanetaryPositions(julianDay: jd)
                    self.calculateHouseCusps(julianDay: jd, latitude: latitude, longitude: longitude, houseSystem: houseSystem.rawValue)
                } else {
                    self.sunPosition = "Date conversion error"
                }

                completion()
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
            self.houseCusps = Array(cusps[1...12]) // set house cusps
            self.ascendant = ascmc[0] // ascendant
            self.midheavenLongitude = ascmc[1] // midheaven

            // TO BE DELETED
            self.printHouseCusps()
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

        if let date = Calendar.current.date(from: dateComponents) {
            let isDST = timeZone.isDaylightSavingTime(for: date)
            let dstOffset = isDST ? timeZone.daylightSavingTimeOffset(for: date) : 0
            let jd = swe_julday(Int32(year), Int32(month), Int32(day), Double(hour) + Double(minute) / 60.0 - Double(dstOffset) / 3600.0, SE_GREG_CAL)

            self.calculatePlanetaryPositions(julianDay: jd)
            self.calculateHouseCusps(julianDay: jd, latitude: latitude, longitude: longitude, houseSystem: houseSystem)
        } else {
            sunPosition = "Date conversion error"
        }
        completion()
    }
    
    // TEMPORARY
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

    
} // class ending


extension AstrologyModel {
    
    /**
     Calls all methods to update planets from Ephemeris to Astrology
     */
    public func calculatePlanetaryPositions(julianDay jd: Double) {
        calculateSunPosition(julianDay: jd)
        calculateMoonPosition(julianDay: jd)
        calculateMercuryPosition(julianDay: jd)
        calculateVenusPosition(julianDay: jd)
        calculateMarsPosition(julianDay: jd)
        calculateJupiterPosition(julianDay: jd)
        calculateSaturnPosition(julianDay: jd)
        calculateUranusPosition(julianDay: jd)
        calculateNeptunePosition(julianDay: jd)
        calculatePlutoPosition(julianDay: jd)
        calculateLilithPosition(julianDay: jd)
        calculateNorthNodePosition(julianDay: jd)
    }
    
    /// Calculates the Sun's position
    private func calculateSunPosition(julianDay jd: Double) {
        updateAstrologicalBodyPosition(julianDay: jd, planet: SE_SUN, updateLongitude: &sunLongitude, updatePosition: &sunPosition)
    }
    
    /// Calculates the Moon's position
    private func calculateMoonPosition(julianDay jd: Double) {
        updateAstrologicalBodyPosition(julianDay: jd, planet: SE_MOON, updateLongitude: &moonLongitude, updatePosition: &moonPosition)
    }
    
    /// Calculates Mercury's position
    private func calculateMercuryPosition(julianDay jd: Double) {
        updateAstrologicalBodyPosition(julianDay: jd, planet: SE_MERCURY, updateLongitude: &mercuryLongitude, updatePosition: &mercuryPosition)
    }
    
    /// Calculates Venus' position
    private func calculateVenusPosition(julianDay jd: Double) {
        updateAstrologicalBodyPosition(julianDay: jd, planet: SE_VENUS, updateLongitude: &venusLongitude, updatePosition: &venusPosition)
    }
    
    /// Calculates Mars' position
    private func calculateMarsPosition(julianDay jd: Double) {
        updateAstrologicalBodyPosition(julianDay: jd, planet: SE_MARS, updateLongitude: &marsLongitude, updatePosition: &marsPosition)
    }
    
    /// Calculates Jupiter's position
    private func calculateJupiterPosition(julianDay jd: Double) {
        updateAstrologicalBodyPosition(julianDay: jd, planet: SE_JUPITER, updateLongitude: &jupiterLongitude, updatePosition: &jupiterPosition)
    }
    
    /// Calculates Saturn's position
    private func calculateSaturnPosition(julianDay jd: Double) {
        updateAstrologicalBodyPosition(julianDay: jd, planet: SE_SATURN, updateLongitude: &saturnLongitude, updatePosition: &saturnPosition)
    }
    
    /// Calculates Uranus' position
    private func calculateUranusPosition(julianDay jd: Double) {
        updateAstrologicalBodyPosition(julianDay: jd, planet: SE_URANUS, updateLongitude: &uranusLongitude, updatePosition: &uranusPosition)
    }
    
    /// Calculates Neptune's position
    private func calculateNeptunePosition(julianDay jd: Double) {
        updateAstrologicalBodyPosition(julianDay: jd, planet: SE_NEPTUNE, updateLongitude: &neptuneLongitude, updatePosition: &neptunePosition)
    }
    
    /// Calculates Pluto's position
    private func calculatePlutoPosition(julianDay jd: Double) {
        updateAstrologicalBodyPosition(julianDay: jd, planet: SE_PLUTO, updateLongitude: &plutoLongitude, updatePosition: &plutoPosition)
    }
    
    // Calculates Lilith's position
    private func calculateLilithPosition(julianDay jd: Double) {
        updateAstrologicalBodyPosition(julianDay: jd, planet: SE_MEAN_APOG, updateLongitude: &lilithLongitude, updatePosition: &lilithPosition)
    }
    
    // Calculates the North Node position
    private func calculateNorthNodePosition(julianDay jd: Double) {
        updateAstrologicalBodyPosition(julianDay: jd, planet: SE_TRUE_NODE, updateLongitude: &northNodeLongitude, updatePosition: &northNodePosition)
    }

    
    
    private func updateAstrologicalBodyPosition(julianDay jd: Double, planet: Int32, updateLongitude longitude: inout Double, updatePosition position: inout String) {
        var xx = [Double](repeating: 0, count: 6)
        var serr = [Int8](repeating: 0, count: 256)
        
        swe_calc_ut(jd, planet, SEFLG_SWIEPH, &xx, &serr)
        longitude = xx[0]
        position = zodiacSignAndDegree(fromLongitude: xx[0])
        
        // TO BE DELETED: console test
        var nameBuffer = [Int8](repeating: 0, count: 30)  // Assuming name will not exceed 29 characters
        swe_get_planet_name(planet, &nameBuffer)
        let planetName = String(cString: nameBuffer)
        
        print("\(planetName) Position: \(position) at \(longitude) degrees")
        
    }
    
    
    public func zodiacSignAndDegree(fromLongitude longitude: Double) -> String {
        let signIndex = Int(longitude / 30) % Zodiac.allCases.count
        let zodiacSign = Zodiac.allCases[signIndex]

        let degreeComponent = longitude.truncatingRemainder(dividingBy: 30)
        let degrees = Int(degreeComponent)
        let minutes = Int((degreeComponent - Double(degrees)) * 60)

        return "\(zodiacSign.rawValue) \(degrees)°\(String(format: "%02d", minutes))'"
    }
}
