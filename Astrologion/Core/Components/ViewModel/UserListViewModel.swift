import Firebase

@MainActor
class UserListViewModel: ObservableObject {
    @Published var users = [User]()
    
    init() {
        Task { await fetchUsers() }
    }
    
    func fetchUsers() async {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let query = FirestoreConstants.UserCollection.limit(to: 20)
        
        guard let snapshot = try? await query.getDocuments() else { return }
        self.users = snapshot.documents.compactMap({ try? $0.data(as: User.self) }).filter({ $0.id != currentUid })
    }
}
