import Foundation

struct AspectDescription: Decodable {
    let leadingPlanet: String
    let trailingPlanet: String
    let aspectType: String
    let title: String
    let description: String
}


func loadAspectDescriptions() -> [AspectDescription] {
    guard let url = Bundle.main.url(forResource: "AspectDescriptionData", withExtension: "json") else {
        fatalError("AspectsDescriptionData.json not found")
    }

    do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode([AspectDescription].self, from: data)
        return jsonData
    } catch {
        fatalError("Failed to decode AspectsData.json: \(error)")
    }
}
