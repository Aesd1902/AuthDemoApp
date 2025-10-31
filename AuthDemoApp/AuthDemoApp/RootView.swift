import SwiftUI

struct RootView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        Group {
            if authVM.user != nil {
                HomeView()
            } else {
                AuthLandingView()
            }
        }
        .animation(.default, value: authVM.user != nil)
    }
}
