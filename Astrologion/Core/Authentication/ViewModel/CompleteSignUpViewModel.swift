import Foundation
import Combine
import CoreLocation

class CompleteSignUpViewModel: ObservableObject {
    @Published var sunPosition: String = "Calculating..."
    @Published var moonPosition: String = "Calculating..."
    @Published var ascendant: String = "Calculating..."

    private var astrologyModel = AstrologyModel()
    private var cancellables: Set<AnyCancellable> = []

    init() {
        astrologyModel.initializeEphemeris()
    }

    func performAstrologicalCalculations(with details: BirthDetails) {
        Task {
            await calculateAstrologicalDetails(
                day: details.day,
                month: details.month,
                year: details.year,
                hour: details.hour,
                minute: details.minute,
                latitude: details.latitude,
                longitude: details.longitude
            )
        }
    }

    private func calculateAstrologicalDetails(day: Int, month: Int, year: Int, hour: Int, minute: Int, latitude: Double, longitude: Double) async {
        do {
            try await astrologyModel.calculateAstrologicalDetails(
                day: day, month: month, year: year,
                hour: hour, minute: minute,
                latitude: latitude, longitude: longitude,
                houseSystem: .placidus
            )
            DispatchQueue.main.async {
                self.updateUIWithAstrologicalData()
            }
        } catch {
            DispatchQueue.main.async {
                self.sunPosition = "Error"
                self.moonPosition = "Error"
                self.ascendant = "Error"
            }
            print("Failed to calculate astrological details: \(error)")
        }
    }
    
    private func updateUIWithAstrologicalData() {
        if let sunPosition = astrologyModel.planetPositions[.Sun]?.position {
            self.sunPosition = extractZodiacSign(from: sunPosition)
        }
        if let moonPosition = astrologyModel.planetPositions[.Moon]?.position {
            self.moonPosition = extractZodiacSign(from: moonPosition)
        }

        let ascendantPosition = astrologyModel.zodiacSignAndDegree(fromLongitude: astrologyModel.ascendant)
        self.ascendant = extractZodiacSign(from: ascendantPosition)
    }

    
    private func extractZodiacSign(from position: String) -> String {
        let components = position.split(separator: " ")
        return components.first.map(String.init) ?? "Unknown"
    }

}
