import Foundation

struct TransitSummaryDescription: Decodable {
    let planet: String
    let sign: String
    let house: Int
    let description: String
}

func loadTransitSummaryData() -> [TransitSummaryDescription] {
    guard let url = Bundle.main.url(forResource: "TransitSummaryDescriptionsData", withExtension: "json") else {
        fatalError("TransitSummaryDescriptionsData.json not found")
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode([TransitSummaryDescription].self, from: data)
        return jsonData
    } catch {
        fatalError("Failed to decode TransitSummaryDescriptionsData.json: \(error)")
    }
}
