import FirebaseFirestore
import FirebaseFirestoreSwift


class ChartService {
    static let shared = ChartService()
    private var astrologyModel: AstrologyModel

    
    init() {
        astrologyModel = AstrologyModel()
        astrologyModel.initializeEphemeris()
    }

    
    ///
    func createChart(for userId: String, with user: User) async throws -> Chart {
        do {
            try await astrologyModel.calculateAstrologicalDetails(
                day: user.birthDay,
                month: user.birthMonth,
                year: user.birthYear,
                hour: user.birthHour,
                minute: user.birthMinute,
                latitude: user.latitude,
                longitude: user.longitude,
                houseSystem: .placidus
            )
        } catch {
            throw error
        }
        
        var chart = astrologyModel.toChart(userId: userId)
        try await saveChart(&chart)
        return chart
    }


    ///
    func saveChart(_ chart: inout Chart) async throws {
        let documentRef = Firestore.firestore().collection("charts").document()
        try documentRef.setData(from: chart)
        chart.id = documentRef.documentID
    }

    
    ///
    func fetchChart(for chartId: String) async throws -> Chart? {
        let chartDoc = try await Firestore.firestore().collection("charts").document(chartId).getDocument()
        let chart = try chartDoc.data(as: Chart.self)
        print("Fetched Chart: \(String(describing: chart))")
        return chart
    }
}
