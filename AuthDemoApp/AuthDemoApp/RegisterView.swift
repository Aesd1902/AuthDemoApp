import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var authVM: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var displayName = ""
    @State private var showingSuccess = false

    var body: some View {
        VStack(spacing: 16) {
            TextField("Full name (optional)", text: $displayName)
                .textFieldStyle(.roundedBorder)
            TextField("Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(.roundedBorder)
            SecureField("Password (6+ chars)", text: $password)
                .textFieldStyle(.roundedBorder)

            if let msg = authVM.authErrorMessage {
                Text(msg)
                    .foregroundColor(.red)
            }

            Button(action: {
                Task {
                    let success = await authVM.register(email: email, password: password, displayName: displayName)
                    showingSuccess = success
                }
            }) {
                if authVM.isLoading {
                    ProgressView()
                } else {
                    Text("Create account")
                        .frame(maxWidth: .infinity)
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(email.isEmpty || password.count < 6 || authVM.isLoading)

            Spacer()
        }
        .padding()
        .navigationTitle("Register")
        .alert("Welcome!", isPresented: $showingSuccess, actions: {
            Button("Continue", role: .cancel) {}
        }, message: {
            Text("Account created successfully. You will be logged in.")
        })
    }
}
