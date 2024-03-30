enum SearchViewModelConfig: String, CaseIterable {
    case followers, following, likes, search, newMessage
    
    var navigationTitle: String {
        switch self {
        case .followers: return "Followers"
        case .following: return "Following"
        case .likes: return "Likes"
        case .search: return "Explore"
        case .newMessage: return "New Message"
        }
    }
}
