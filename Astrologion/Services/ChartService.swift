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
        
        // parsing planets
        let planetaryPositions = astrologicalPointPositions.reduce(into: [String: String]()) { (dict, tuple) in
            let (planet, longitude) = tuple
            dict[planet.rawValue] = zodiacSignAndDegree(fromLongitude: longitude)
        }
        
        // parsing houses
        let houseCuspsDict = houseCusps.enumerated().reduce(into: [String: String]()) { (dict, tuple) in
            let (index, cusp) = tuple
            dict["House \(index + 1)"] = zodiacSignAndDegree(fromLongitude: cusp)
        }
        
        // parsing aspects
        let aspectsList = calculateAspects().map { aspectData -> String in
            return "\(aspectData.planet1.rawValue)-\(aspectData.planet2.rawValue)-\(aspectData.aspect)-\(aspectData.angleDifference)"
        }
        
        // create chart object
        return Chart(
            userId: userId,
            sunSign: extractZodiacSign(from: sunPosition),
            moonSign: extractZodiacSign(from: moonPosition),
            ascendantSign: extractZodiacSign(from: zodiacSignAndDegree(fromLongitude: ascendant)),
            planetaryPositions: planetaryPositions,
            houseCusps: houseCuspsDict,
            aspects: aspectsList
        )
    }
}

