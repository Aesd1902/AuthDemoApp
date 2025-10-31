import SwiftUI

struct AuthLandingView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("Welcome")
                    .font(.largeTitle).bold()
                Text("Sign in to continue")
                    .foregroundColor(.secondary)
                NavigationLink("Login", destination: LoginView())
                    .buttonStyle(.borderedProminent)
                NavigationLink("Register", destination: RegisterView())
                    .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}
