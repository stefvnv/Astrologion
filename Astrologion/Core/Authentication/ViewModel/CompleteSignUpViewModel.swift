import Foundation
import CoreLocation
import Combine

class CompleteSignUpViewModel: ObservableObject {
    @Published var sunPosition: String = ""
    @Published var moonPosition: String = ""
    @Published var ascendant: String = ""
    
    private var astrologyModel = AstrologyModel()
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        astrologyModel.initializeEphemeris()
        setupBindings()
    }
    
    private func setupBindings() {
        astrologyModel.$planetPositions
            .receive(on: RunLoop.main)
            .sink { [weak self] positions in
                self?.updatePositions(positions: positions)
            }
            .store(in: &cancellables)
        
        astrologyModel.$ascendant
            .receive(on: RunLoop.main)
            .map { $0 }
            .sink { [weak self] ascendant in
                self?.updateAscendant(ascendant: ascendant)
            }
            .store(in: &cancellables)
    }
    
    private func updatePositions(positions: [Planet: (position: String, longitude: Double)]) {
        if let sun = positions[.Sun]?.position {
            sunPosition = extractZodiacSign(from: sun)
        }
        if let moon = positions[.Moon]?.position {
            moonPosition = extractZodiacSign(from: moon)
        }
    }
    
    private func updateAscendant(ascendant: Double) {
        let ascendantPosition = astrologyModel.zodiacSignAndDegree(fromLongitude: ascendant)
        self.ascendant = extractZodiacSign(from: ascendantPosition)
    }
    
    private func extractZodiacSign(from position: String) -> String {
        let components = position.components(separatedBy: " ")
        return components.first ?? "Unknown"
    }
    
    func calculateAstrologicalDetails(day: Int, month: Int, year: Int, hour: Int, minute: Int, latitude: Double, longitude: Double) {
        Task {
            try await astrologyModel.calculateAstrologicalDetails(
                day: day, month: month, year: year,
                hour: hour, minute: minute,
                latitude: latitude, longitude: longitude,
                houseSystem: .placidus
            )
        }
    }
}
