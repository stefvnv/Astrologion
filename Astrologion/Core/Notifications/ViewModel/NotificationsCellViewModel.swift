import SwiftUI

@MainActor
class NotificationCellViewModel: ObservableObject {
    @Published var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    func follow() {
        Task {
            try await UserService.follow(uid: notification.uid)
            NotificationService.uploadNotification(toUid: self.notification.uid, type: .follow)
            self.notification.isFollowed = true
        }
    }
    
    func unfollow() {
        Task {
            try await UserService.unfollow(uid: notification.uid)
            self.notification.isFollowed = false
        }
    }
}
