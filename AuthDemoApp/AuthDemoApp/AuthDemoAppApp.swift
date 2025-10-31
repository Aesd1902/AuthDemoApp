import SwiftUI
import FirebaseCore


@main
struct AuthDemoApp: App {
    // initialize Firebase when the app launches
    init() {
        FirebaseApp.configure()
    }

    // make AuthViewModel available to all views
    @StateObject private var authVM = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authVM)
        }
    }
}
