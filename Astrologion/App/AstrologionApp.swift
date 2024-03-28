import SwiftUI
import Firebase
import SwissEphemeris

@main
struct AstrologionApp: App {
    
    ///
    init() {
        JPLFileManager.setEphemerisPath()
        FirebaseApp.configure()
    }
    
    ///
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
