import SwiftUI
import PhotosUI
import FirebaseFirestoreSwift
import Firebase
import CoreLocation

@MainActor
class EditProfileViewModel: ObservableObject {
    @Published var user: User
    @Published var uploadComplete = false
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    @Published var profileImage: Image?
    private var uiImage: UIImage?
    
    var fullname = ""
    var bio = ""
    var username = ""
    
    @Published var birthDate: Date
    @Published var birthTime: Date
    @Published var birthLocation: String
    @Published var latitude: Double
    @Published var longitude: Double

    private let geocoder = CLGeocoder()

    init(user: User) {
        self.user = user
        self.fullname = user.fullname ?? ""
        self.bio = user.bio ?? ""
        self.username = user.username
        self.birthLocation = user.birthLocation
        
        self.birthDate = DateComponents(calendar: .current, year: user.birthYear, month: user.birthMonth, day: user.birthDay).date ?? Date()
        self.birthTime = DateComponents(calendar: .current, hour: user.birthHour, minute: user.birthMinute).date ?? Date()
        self.latitude = user.latitude
        self.longitude = user.longitude
    }
    
    @MainActor
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
    }
    
    func updateProfileImage(_ uiImage: UIImage) async throws {
        let imageUrl = try? await ImageUploader.uploadImage(image: uiImage, type: .profile)
        self.user.profileImageUrl = imageUrl
    }
    
    
    func updateUserData() async throws {
        var data: [String: Any] = [:]
        
        if let uiImage = uiImage {
            try? await updateProfileImage(uiImage)
            data["profileImageUrl"] = user.profileImageUrl
        }
        
        data["fullname"] = fullname
        data["bio"] = bio
        data["username"] = username
        
        let birthDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: birthDate)
        let birthTimeComponents = Calendar.current.dateComponents([.hour, .minute], from: birthTime)
        
        data["birthYear"] = birthDateComponents.year
        data["birthMonth"] = birthDateComponents.month
        data["birthDay"] = birthDateComponents.day
        data["birthHour"] = birthTimeComponents.hour
        data["birthMinute"] = birthTimeComponents.minute
        data["latitude"] = latitude
        data["longitude"] = longitude
        data["birthLocation"] = birthLocation

        if user.birthYear != birthDateComponents.year || user.birthMonth != birthDateComponents.month || user.birthDay != birthDateComponents.day ||
           user.birthHour != birthTimeComponents.hour || user.birthMinute != birthTimeComponents.minute ||
           user.latitude != latitude || user.longitude != longitude || user.birthLocation != birthLocation {
            
            let newChart = await calculateAndCreateChart(
                userId: user.id, birthYear: birthDateComponents.year!, birthMonth: birthDateComponents.month!, birthDay: birthDateComponents.day!,
                birthHour: birthTimeComponents.hour!, birthMinute: birthTimeComponents.minute!, latitude: latitude, longitude: longitude
            )
            if let chartId = newChart?.id {
                data["chartId"] = chartId
            }
        }
        try await FirestoreConstants.UserCollection.document(user.id).updateData(data)
    }
    
    private func calculateAndCreateChart(
        userId: String, birthYear: Int, birthMonth: Int, birthDay: Int,
        birthHour: Int, birthMinute: Int, latitude: Double, longitude: Double
    ) async -> Chart? {
        let astrologyModel = AstrologyModel()
        astrologyModel.initializeEphemeris()

        do {
            try await astrologyModel.calculateAstrologicalDetails(
                day: birthDay, month: birthMonth, year: birthYear,
                hour: birthHour, minute: birthMinute,
                latitude: latitude, longitude: longitude,
                houseSystem: .placidus
            )

            var chart = astrologyModel.toChart(userId: userId)

            try await ChartService.shared.saveChart(&chart)
            return chart
        } catch {
            print("Failed to create and save chart: \(error.localizedDescription)")
            return nil
        }
    }
    
    func refreshView() async {
        do {
            let updatedUser = try await UserService.fetchUser(withUid: user.id)
            DispatchQueue.main.async {
                self.user = updatedUser
                self.fullname = updatedUser.fullname ?? ""
                self.bio = updatedUser.bio ?? ""
                self.username = updatedUser.username
                self.birthDate = DateComponents(calendar: .current, year: updatedUser.birthYear, month: updatedUser.birthMonth, day: updatedUser.birthDay).date ?? Date()
                self.birthTime = DateComponents(calendar: .current, hour: updatedUser.birthHour, minute: updatedUser.birthMinute).date ?? Date()
                self.birthLocation = updatedUser.birthLocation
                self.latitude = updatedUser.latitude
                self.longitude = updatedUser.longitude
            }
        } catch {
            print("Error fetching user data: \(error)")
        }
    }
    

    // MARK: - Location
    
    func geocodeLocation(_ locationName: String, completion: @escaping () -> Void) {
        geocoder.geocodeAddressString(locationName) { [weak self] (placemarks, error) in
            DispatchQueue.main.async {
                if let placemark = placemarks?.first, let location = placemark.location {
                    self?.latitude = location.coordinate.latitude
                    self?.longitude = location.coordinate.longitude
                    completion()
                } else {
                    print("Geocoding failed: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }

} // end
