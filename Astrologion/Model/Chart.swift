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

