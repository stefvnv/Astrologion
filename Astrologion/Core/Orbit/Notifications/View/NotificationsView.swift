import SwiftUI

struct NotificationsView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = NotificationsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach($viewModel.notifications) { notification in
                        NotificationCell(notification: notification)
                            .padding(.top)
                            .onAppear {
                                if notification.id == viewModel.notifications.last?.id ?? "" {
                                    print("DEBUG: paginate here..")
                                }
                            }
                    }
                }
                .navigationTitle("Notifications")
                .navigationBarTitleDisplayMode(.inline)
            }
            .background(Color.theme.darkBlue)
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
        .background(Color.theme.darkBlue)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
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

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
