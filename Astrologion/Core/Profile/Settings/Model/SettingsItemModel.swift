import Foundation

enum SettingsItemModel: Int, Identifiable, Hashable, CaseIterable {
    case settings
    case logout
    case deleteAccount
    
    var title: String {
        switch self {
        case .settings:
            return "Settings"
        case .logout:
            return "Logout"
        case .deleteAccount:
            return "Delete Account"
        }
    }
    
    var imageName: String {
        switch self {
        case .settings:
            return "gear"
        case .logout:
            return "arrow.left.square"
        case .deleteAccount:
            return "trash"
        }
    }
    
    var id: Int { return self.rawValue }
}
