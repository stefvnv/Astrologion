import Foundation

struct PlanetaryPlacementHouseDescription: Decodable {
    let planet: String
    let house: String
    let description: String
}

func loadAstrologicalHouseData() -> [PlanetaryPlacementHouseDescription] {
    guard let url = Bundle.main.url(forResource: "PlanetaryPlacementHouseData", withExtension: "json") else {
        fatalError("PlanetaryPlacementHouseData.json not found")
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode([PlanetaryPlacementHouseDescription].self, from: data)
        return jsonData
    } catch {
        fatalError("Failed to decode PlanetaryPlacementHouseData.json: \(error)")
    }
}
