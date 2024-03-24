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
        
        let chart = Chart(
            userId: userId,
            sunSign: astrologyModel.sunPosition,
            moonSign: astrologyModel.moonPosition,
            ascendantSign: astrologyModel.zodiacSignAndDegree(fromLongitude: astrologyModel.ascendant),
            planetaryPositions: astrologyModel.planetaryPositionsDictionary(),
            houseCusps: astrologyModel.houseCuspsDictionary()
        )
        
        let encodedChart = try Firestore.Encoder().encode(chart)
        try await Firestore.firestore().collection("charts").document(userId).setData(encodedChart)
        return chart
    }

    

    func fetchChart(for userId: String) async throws -> Chart? {
        let documentSnapshot = try await Firestore.firestore().collection("charts").document(userId).getDocument()
        return try? documentSnapshot.data(as: Chart.self)
    }

    func updateChart(for userId: String, with details: Chart) async throws {
        let encodedDetails = try Firestore.Encoder().encode(details)
        try await Firestore.firestore().collection("charts").document(userId).updateData(encodedDetails)
    }

    func deleteChart(for userId: String) async throws {
        try await Firestore.firestore().collection("charts").document(userId).delete()
    }
}

extension AstrologyModel {
    func planetaryPositionsDictionary() -> [String: String] {
        let positions = astrologicalPointPositions.reduce(into: [String: String]()) { (dict, tuple) in
            let (planet, longitude) = tuple
            dict[planet.rawValue] = zodiacSignAndDegree(fromLongitude: longitude)
        }
        return positions
    }

    func houseCuspsDictionary() -> [String: String] {
        let dict = houseCusps.enumerated().reduce(into: [String: String]()) { (dict, tuple) in
            let (index, cusp) = tuple
            dict["House \(index + 1)"] = zodiacSignAndDegree(fromLongitude: cusp)
        }
        return dict
    }
}
