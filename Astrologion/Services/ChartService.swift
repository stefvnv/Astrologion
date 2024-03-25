import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation

class ChartService {
    static let shared = ChartService()
    private var astrologyModel: AstrologyModel?

    private init() {
        astrologyModel = AstrologyModel()
        astrologyModel?.initializeEphemeris()
    }

    func createChart(for userId: String, with user: User) async throws -> Chart {
        guard let astrologyModel = self.astrologyModel else {
            throw NSError(domain: "AstrologyModelInitializationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to initialize AstrologyModel"])
        }
        
        await astrologyModel.populateAndCalculate(
            day: user.birthDay,
            month: user.birthMonth,
            year: user.birthYear,
            hour: user.birthHour,
            minute: user.birthMinute,
            latitude: user.latitude,
            longitude: user.longitude
        )
        
        let chart = astrologyModel.toChart(userId: userId)
        try await saveChart(chart)
        return chart
    }
    
    func saveChart(_ chart: Chart) async throws {
        let documentRef = Firestore.firestore().collection("charts").document(chart.userId)
        try documentRef.setData(from: chart)
    }

    func fetchChart(for userId: String) async throws -> Chart? {
        let documentSnapshot = try await Firestore.firestore().collection("charts").document(userId).getDocument()
        return try? documentSnapshot.data(as: Chart.self)
    }

    func updateChart(for userId: String, with details: Chart) async throws {
        let documentRef = Firestore.firestore().collection("charts").document(userId)
        try documentRef.setData(from: details)
    }

    func deleteChart(for userId: String) async throws {
        let documentRef = Firestore.firestore().collection("charts").document(userId)
        try await documentRef.delete()
    }
}


extension AstrologyModel {
    func toChart(userId: String) -> Chart {
        
        // parse planets
        let planetaryPositionsDict = self.planetaryPositions.reduce(into: [String: String]()) { (dict, tuple) in
            let (point, longitude) = tuple
            dict[point.symbol ?? "\(point)"] = zodiacSignAndDegree(fromLongitude: longitude)
        }

        // parse houses
        let houseCuspsDict = houseCusps.enumerated().reduce(into: [String: String]()) { (dict, tuple) in
            let (index, cusp) = tuple
            dict["House \(index + 1)"] = zodiacSignAndDegree(fromLongitude: cusp)
        }

        // parse aspects
        let aspectsList = calculateAspects().map { aspectData -> String in
            let planet1Symbol = aspectData.planet1.symbol ?? "\(aspectData.planet1)"
            let planet2Symbol = aspectData.planet2.symbol ?? "\(aspectData.planet2)"
            return "\(planet1Symbol)-\(planet2Symbol)-\(aspectData.aspect)-\(aspectData.angleDifference)"
        }

        // extract sun andmoon signs
        let sunSign = planetaryPositions[.Sun].flatMap { extractZodiacSign(from: zodiacSignAndDegree(fromLongitude: $0)) } ?? "Unknown"
        let moonSign = planetaryPositions[.Moon].flatMap { extractZodiacSign(from: zodiacSignAndDegree(fromLongitude: $0)) } ?? "Unknown"
        let ascendantSign = extractZodiacSign(from: zodiacSignAndDegree(fromLongitude: self.ascendant))

        // create and return chart object
        return Chart(
            userId: userId,
            sunSign: sunSign,
            moonSign: moonSign,
            ascendantSign: ascendantSign,
            planetaryPositions: planetaryPositionsDict,
            houseCusps: houseCuspsDict,
            aspects: aspectsList
        )
    }

    
    // Helper methods
    func zodiacSignAndDegree(fromLongitude longitude: Double) -> String {
        let signIndex = Int(longitude / 30) % Zodiac.allCases.count
        let zodiacSign = Zodiac.allCases[signIndex]

        let degreeComponent = longitude.truncatingRemainder(dividingBy: 30)
        let degrees = Int(degreeComponent)
        let minutes = Int((degreeComponent - Double(degrees)) * 60)

        return "\(zodiacSign.rawValue) \(degrees)°\(String(format: "%02d", minutes))'"
    }

    func extractZodiacSign(from position: String) -> String {
        let components = position.components(separatedBy: " ")
        return components.first ?? "Unknown"
    }
}
