import FirebaseFirestoreSwift
import Firebase

struct Chart: Identifiable, Codable {
    @DocumentID var id: String?
    let userId: String
    var sunSign: String
    var moonSign: String
    var ascendantSign: String
    var planetaryPositions: [String: String]  // Key: Planet, Value: Sign and degree
    var houseCusps: [String: String]  // Key: House number, Value: Sign and degree
    var aspects: [String: String]  // Key: Aspect description, Value: Aspect angle

    var timestamp: Timestamp?
}


extension AstrologyModel {
    convenience init(from chart: Chart) {
        self.init()
        
        self.sunPosition = chart.sunSign
        self.moonPosition = chart.moonSign
    }
}
