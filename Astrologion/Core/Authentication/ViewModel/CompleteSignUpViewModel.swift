import Foundation
import CoreLocation
import Combine

class CompleteSignUpViewModel: ObservableObject {
    @Published var sunPosition: String = ""
    @Published var moonPosition: String = ""
    @Published var ascendant: String = "" // Make sure this is a String to match the other two

    private var astrologyModel = AstrologyModel()
    private var cancellables: Set<AnyCancellable> = []

    init() {
        astrologyModel.initializeEphemeris()
    }

    func calculateAstrologicalDetails(day: Int, month: Int, year: Int, hour: Int, minute: Int, latitude: Double, longitude: Double) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.astrologyModel.calculateAstrologicalDetails(
                day: day, month: month, year: year,
                hour: hour, minute: minute,
                latitude: latitude, longitude: longitude,
                houseSystem: .placidus
            ) { [weak self] in
                DispatchQueue.main.async {
                    // Update the UI on the main thread
                    self?.sunPosition = self?.astrologyModel.sunPosition ?? "Unknown"
                    self?.moonPosition = self?.astrologyModel.moonPosition ?? "Unknown"
                    if let ascendantDegree = self?.astrologyModel.ascendant {
                        self?.ascendant = self?.astrologyModel.zodiacSignAndDegree(fromLongitude: ascendantDegree) ?? "Unknown"
                    }
                }
            }
        }
    }
}
