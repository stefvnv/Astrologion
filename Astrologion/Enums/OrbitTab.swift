enum OrbitTab: String, CaseIterable {
    case followers, following, search
    
    var navigationTitle: String {
        switch self {
        case .search: return "Explore"
        case .followers: return "Followers"
        case .following: return "Following"
        }
    }

    // TODO: Change names/add icons
    var text: String {
        switch self {
        case .search:
            return "Search User"
        case .followers:
            return "Followers"
        case .following:
            return "Following"
        }
    }
}
