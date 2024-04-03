enum OrbitTab: String, CaseIterable {
    case search, followers, following
    
    var navigationTitle: String {
        switch self {
        case .search: return "Search"
        case .followers: return "Followers"
        case .following: return "Following"
        }
    }

    // TODO: Change names/add icons
    var text: String {
        switch self {
        case .search:
            return "Search"
        case .followers:
            return "Followers"
        case .following:
            return "Following"
        }
    }
}
