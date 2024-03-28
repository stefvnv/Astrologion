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
//    func calculateAstrologicalDetails(day: Int, month: Int, year: Int, hour: Int, minute: Int, latitude: Double, longitude: Double) {
//        Task {
//            do {
//                try await self.astrologyModel.calculateAstrologicalDetails(
//                    day: day, month: month, year: year,
//                    hour: hour, minute: minute,
//                    latitude: latitude, longitude: longitude,
//                    houseSystem: .placidus
//                )
//                
//                DispatchQueue.main.async { [weak self] in
//                    guard let self = self else { return }
//                    
//                    // Access positions using the planetaryPositions dictionary
//                    if let sunLongitude = self.astrologyModel.planetaryPositions[.Sun],
//                       let moonLongitude = self.astrologyModel.planetaryPositions[.Moon] {
//                        
//                        let sunPosition = self.astrologyModel.zodiacSignAndDegree(fromLongitude: sunLongitude)
//                        let moonPosition = self.astrologyModel.zodiacSignAndDegree(fromLongitude: moonLongitude)
//                        
//                        // Directly use ascendantLongitude since it's not optional
//                        let ascendantLongitude = self.astrologyModel.ascendant
//                        let ascendantSign = self.astrologyModel.zodiacSignAndDegree(fromLongitude: ascendantLongitude)
//                        
//                        // Extract the zodiac sign from the position string
//                        self.sunPosition = self.astrologyModel.extractZodiacSign(from: sunPosition)
//                        self.moonPosition = self.astrologyModel.extractZodiacSign(from: moonPosition)
//                        self.ascendant = self.astrologyModel.extractZodiacSign(from: ascendantSign)
//                    }
//                }
//            } catch {
//                print("An error occurred while calculating astrological details: \(error)")
//            }
//        }
//    }
}
