import SwiftUI

struct NewMessageView: View {
    @State var searchText = ""
    @Binding var startChat: Bool
    @Binding var user: User?
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel = SearchViewModel(config: .newMessage)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Text("To: ")
                        .foregroundColor(Color.white.opacity(0.4))
                        .padding(8)
                        .font(.custom("Dosis", size: 16))

                    TextField("", text: $searchText)
                        .onChange(of: searchText) { newValue in
                            searchText = newValue.lowercased()
                        }
                        .font(.custom("Dosis", size: 16))
                        .foregroundColor(Color.white)
                        .padding(8)
                        .background(Color.theme.lightLavender.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.horizontal)

                // Users list
                LazyVStack(alignment: .leading) {
                    ForEach(searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText)) { user in
                        UserCell(user: user)
                            .onTapGesture {
                                dismiss()
                                startChat.toggle()
                                self.user = user
                            }
                    }
                }
                .padding(.horizontal)
            }
            .background(Color.theme.darkBlue.edgesIgnoringSafeArea(.all))
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(Color.theme.yellow)
                    .font(.custom("Dosis", size: 14))
                }
            }
        }
        .background(Color.theme.darkBlue.edgesIgnoringSafeArea(.all))
    }
}
