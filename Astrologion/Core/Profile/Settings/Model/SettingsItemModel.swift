import Foundation

enum SettingsItemModel: Int, Identifiable, Hashable, CaseIterable {
    case settings
    case yourActivity
    case saved
    case logout
    
    var title: String {
        switch self {
        case .settings:
            return "Settings"
        case .yourActivity:
            return "Your Activity"
        case .saved:
            return "Saved"
        case .logout:
            return "Logout"
        }
    }
    
    var imageName: String {
        switch self {
        case .settings:
            return "gear"
        case .yourActivity:
            return "cursorarrow.click.badge.clock"
        case .saved:
            return "bookmark"
        case .logout:
            return "arrow.left.square"
        }
    }
    
    var id: Int { return self.rawValue }
}
