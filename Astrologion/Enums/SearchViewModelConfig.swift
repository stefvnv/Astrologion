enum SearchViewModelConfig: Hashable {
    case followers(String)
    case following(String)
    case likes(String)
    case search
    case newMessage
    
    var navigationTitle: String {
        switch self {
        case .followers:
            return "Followers"
        case .following:
            return "Following"
        case .likes:
            return "Likes"
        case .search:
            return "Search"
        case .newMessage:
            return "NewMessage"
        }
    }
}
