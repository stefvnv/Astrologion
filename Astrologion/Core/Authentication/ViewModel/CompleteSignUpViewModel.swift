import Foundation
import CoreLocation
import Combine

class CompleteSignUpViewModel: ObservableObject {
    @Published var sunPosition: String = ""
    @Published var moonPosition: String = ""
    @Published var ascendant: String = ""

    private var astrologyModel = AstrologyModel()

    
    ///
    init() {
        astrologyModel.initializeEphemeris()
    }

    
    ///
    func calculateAstrologicalDetails(day: Int, month: Int, year: Int, hour: Int, minute: Int, latitude: Double, longitude: Double) {
        Task {
            await self.astrologyModel.calculateAstrologicalDetails(
                day: day, month: month, year: year,
                hour: hour, minute: minute,
                latitude: latitude, longitude: longitude,
                houseSystem: .placidus
            )

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let sunPosition = self.astrologyModel.extractZodiacSign(from: self.astrologyModel.sunPosition)
                let moonPosition = self.astrologyModel.extractZodiacSign(from: self.astrologyModel.moonPosition)
                let ascendant = self.astrologyModel.extractZodiacSign(from: self.astrologyModel.zodiacSignAndDegree(fromLongitude: self.astrologyModel.ascendant))
                
                self.sunPosition = sunPosition
                self.moonPosition = moonPosition
                self.ascendant = ascendant
            }
        }
    }
}
