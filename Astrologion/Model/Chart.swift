import FirebaseFirestoreSwift
import Firebase

struct Chart: Codable {
    @DocumentID var id: String?
    let userId: String
    var sunSign: String
    var moonSign: String
    var ascendantSign: String
    var planetaryPositions: [String: String]
    var houseCusps: [String: String]
    var aspects: [String]

    var timestamp: Timestamp?
}


extension AstrologyModel {
    convenience init(from chart: Chart) {
        self.init()
        self.sunPosition = chart.sunSign
        self.moonPosition = chart.moonSign

        // TO BE DELETED - Test
        print("AstrologyModel initialized from Chart: Sun Sign - \(self.sunPosition), Moon Sign - \(self.moonPosition)")
    }
}
