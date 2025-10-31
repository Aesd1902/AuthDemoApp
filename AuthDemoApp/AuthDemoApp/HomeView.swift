import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @EnvironmentObject var authVM: AuthViewModel

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if let user = authVM.user {
                    Text("Hello, \(user.displayName ?? user.email ?? "User")")
                        .font(.title2).bold()
                    Text("UID: \(user.uid)")
                        .font(.caption).foregroundColor(.secondary)
                }

                Button("Sign Out", action: {
                    _ = authVM.signOut()
                })
                .buttonStyle(.bordered)

                Spacer()
            }
            .padding()
            .navigationTitle("Home")
        }
    }
}
