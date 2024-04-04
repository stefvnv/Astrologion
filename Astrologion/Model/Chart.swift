import FirebaseFirestoreSwift
import Firebase

struct Chart: Codable {
    @DocumentID var id: String?
    let userId: String
    var planetaryPositions: [String: String] 
    var planetaryHousePositions: [String: Int]
    var houseCusps: [String: String]
    var aspects: [String]
}
