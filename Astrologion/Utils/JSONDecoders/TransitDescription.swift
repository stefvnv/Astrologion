import Foundation

struct TransitDescription: Decodable {
    let transit: String
    let title: String
    let description: String
}

func loadTransitData() -> [TransitDescription] {
    guard let url = Bundle.main.url(forResource: "TransitDescriptionsData", withExtension: "json") else {
        fatalError("TransitDescriptionsData.json not found")
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode([TransitDescription].self, from: data)
        return jsonData
    } catch {
        fatalError("Failed to decode TransitDescriptionsData.json: \(error)")
    }
}
