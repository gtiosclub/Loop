//
//  AuthManager.swift
//  Loop
//
//  Created by Danny Byrd on 10/8/24.
//

import Foundation
import FirebaseAuth

class AuthManager: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String?

    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        // Validate email and password are not empty
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "Email and Password cannot be empty."
            completion(false)
            return
        }

        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    if (error.localizedDescription.contains("malformed or has expired")) {
                        self?.errorMessage = "No account found"
                    } else {
                        self?.errorMessage = error.localizedDescription
                    }
                    completion(false)
                } else {
                    self?.isAuthenticated = true
                    self?.errorMessage = nil
                    completion(true)
                }
            }
        }
    }
    
    func signUp(email: String, password: String) async -> Bool {
        // Validate email and password are not empty
        guard !email.isEmpty, !password.isEmpty else {
            self.errorMessage = "Email and Password cannot be empty."
            return false
        }

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.isAuthenticated = true
            self.errorMessage = nil
            return true
        } catch {
            self.errorMessage = "Account creation failed"
            return false
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Bool) -> Void) {
            // Validate email and password are not empty
            guard !email.isEmpty, !password.isEmpty else {
                self.errorMessage = "Email and Password cannot be empty."
                completion(false)
                return
            }

            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                DispatchQueue.main.async {
                    if error != nil {
                        self?.errorMessage = "Account creation failed"
                        completion(false)
                    } else {
                        self?.isAuthenticated = true
                        self?.errorMessage = nil
                        completion(true)
                    }
                }
            }
        }

    func signOut() {
        do {
            try Auth.auth().signOut()
            self.isAuthenticated = false
        } catch let signOutError as NSError {
            self.errorMessage = signOutError.localizedDescription
        }
    }
}
