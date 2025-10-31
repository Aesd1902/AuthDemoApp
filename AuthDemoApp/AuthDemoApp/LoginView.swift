import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var showResetAlert = false
    @State private var resetEmail = ""
    @State private var showingError = false

    var body: some View {
        VStack(spacing: 16) {
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            if let msg = authVM.authErrorMessage {
                Text(msg)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            Button(action: {
                Task {
                    let success = await authVM.login(email: email, password: password)
                    if !success { showingError = true }
                }
            }) {
                if authVM.isLoading {
                    ProgressView()
                } else {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(email.isEmpty || password.isEmpty || authVM.isLoading)

            Button("Forgot Password?") {
                resetEmail = email
                showResetAlert = true
            }
            .foregroundColor(.blue)

            Spacer()
        }
        .padding()
        .navigationTitle("Login")
        .alert("Reset Password", isPresented: $showResetAlert, actions: {
            TextField("Email", text: $resetEmail)
            Button("Send", action: {
                Task {
                    let _ = await authVM.sendPasswordReset(email: resetEmail)
                }
            })
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("Enter the email to receive a password reset link.")
        })
    }
}
