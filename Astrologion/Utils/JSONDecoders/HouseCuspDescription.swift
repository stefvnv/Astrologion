import Foundation

struct HouseCuspDescription: Decodable {
    let house: Int
    let sign: String
    let description: String
}

func loadHouseCuspData() -> [HouseCuspDescription] {
    guard let url = Bundle.main.url(forResource: "HouseCuspData", withExtension: "json") else {
        fatalError("HouseCuspData.json not found")
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([HouseCuspDescription].self, from: data)
    } catch {
        fatalError("Failed to decode HouseCuspData.json: \(error)")
    }
}

