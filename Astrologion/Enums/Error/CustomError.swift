import Foundation

enum CustomError: Error {
    case missingLocationData
    case invalidEmail
    case invalidUsername
    case missingDateComponents
    case missingTimeComponents
    case timezoneError
    case dateConversionError
    case userNotLoggedIn
    case unwrappedError
    
    var errorMessage: String {
        switch self {
        case .missingLocationData:
            return "Location data is missing. Please ensure you have selected a valid location."
        case .invalidEmail:
            return "The email entered is invalid. Please check and try again."
        case .invalidUsername:
            return "The username entered is invalid or already in use. Please try a different username."
        case .missingDateComponents:
            return "Date components (year, month, day) are missing or invalid."
        case .missingTimeComponents:
            return "Time components (hour, minute) are missing or invalid."
        case .timezoneError:
            return "Timezone data could not be determined. Please ensure the location is correct."
        case .dateConversionError:
            return "There was a problem converting your date. Please check the date components and try again."
        case .userNotLoggedIn:
            return "You are not logged in. Please log in to continue."
        case .unwrappedError:
            return "Unwrapping Optional value failed."
        }
    }
}
