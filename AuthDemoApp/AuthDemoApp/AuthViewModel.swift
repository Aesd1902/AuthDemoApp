import Foundation
import FirebaseAuth
import SwiftUI
import Combine

/// ObservableObject that holds authentication state and exposes auth methods
@MainActor
final class AuthViewModel: ObservableObject {
    @Published var user: User? = nil       // Firebase User model (optional)
    @Published var isLoading = false
    @Published var authErrorMessage: String?

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
        // attach listener to Firebase Auth state changes
        handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            Task { @MainActor in
                self?.user = user
            }
        }
    }

    deinit {
        if let h = handle { Auth.auth().removeStateDidChangeListener(h) }
    }

    // MARK: - Auth functions

    func register(email: String, password: String, displayName: String? = nil) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            // optionally set display name
            if let name = displayName, !name.isEmpty {
                let changeRequest = result.user.createProfileChangeRequest()
                changeRequest.displayName = name
                try await changeRequest.commitChanges()
            }
            self.user = result.user
            return true
        } catch {
            authErrorMessage = error.localizedDescription
            return false
        }
    }

    func login(email: String, password: String) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.user = result.user
            return true
        } catch {
            authErrorMessage = error.localizedDescription
            return false
        }
    }

    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            self.user = nil
            return true
        } catch {
            authErrorMessage = error.localizedDescription
            return false
        }
    }

    func sendPasswordReset(email: String) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
            return true
        } catch {
            authErrorMessage = error.localizedDescription
            return false
        }
    }
}
