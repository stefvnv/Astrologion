import Foundation
import Combine
import CoreLocation

class CompleteSignUpViewModel: ObservableObject {
    @Published var sunPosition: String = "Calculating..."
    @Published var moonPosition: String = "Calculating..."
    @Published var ascendant: String = "Calculating..."
    @Published var isDataReady = false
    
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
        if let sun = astrologyModel.planetPositions[.Sun]?.position,
           let moon = astrologyModel.planetPositions[.Moon]?.position {
            let asc = astrologyModel.ascendant
            DispatchQueue.main.async {
                self.sunPosition = self.extractZodiacSign(from: sun)
                self.moonPosition = self.extractZodiacSign(from: moon)
                self.ascendant = self.extractZodiacSign(from: self.astrologyModel.zodiacSignAndDegree(fromLongitude: asc))
                self.isDataReady = true
            }
        } else {
            DispatchQueue.main.async {
                self.sunPosition = "Error"
                self.moonPosition = "Error"
                self.ascendant = "Error"
            }
        }
    }
    
    private func extractZodiacSign(from position: String) -> String {
        let components = position.components(separatedBy: " ")
        return components.first ?? "Unknown"
    }
}
