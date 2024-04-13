import SwiftUI

struct ConversationsView: View {
    @State var isShowingNewMessageView = false
    @State var showChat = false
    @State var user: User?
    @StateObject var viewModel = ConversationsViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.recentMessages) { message in
                        NavigationLink {
                            if let user = message.user {
                                ChatView(user: user)
                            }
                        } label: {
                            ConversationCell(message: message)
                        }
                    }
                }.padding()
            }
            .toolbar(.hidden, for: .tabBar)
            .navigationTitle("Conversations")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $isShowingNewMessageView, content: {
                NewMessageView(startChat: $showChat, user: $user)
            })
            .toolbar(content: {
                Button {
                    isShowingNewMessageView.toggle()
                } label: {
                    Image("write")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .scaledToFit()
                }
            })
            .onAppear {
                viewModel.loadData()
            }
            .navigationDestination(isPresented: $showChat) {
                if let user = user {
                    ChatView(user: user)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .background(Color.theme.darkBlue)
    }
    
    var backButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
                .foregroundColor(Color.theme.lightLavender)
        }
    }
}

struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView()
    }
}
