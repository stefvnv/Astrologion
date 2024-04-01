import Foundation
import SwiftUI

struct PlanetaryPlacement: Decodable {
    let planet: String
    let sign: String
    let description: String
}


///
func loadAstrologicalData() -> [PlanetaryPlacement] {
    guard let url = Bundle.main.url(forResource: "PlanetaryPlacementData", withExtension: "json") else {
        fatalError("PlanetaryPlacementData.json not found")
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode([PlanetaryPlacement].self, from: data)
        return jsonData
    } catch {
        fatalError("Failed to decode PlanetaryPlacementData.json: \(error)")
    }
}
