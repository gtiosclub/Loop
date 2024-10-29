//
//  AuthManager.swift
//  Loop
//
//  Created by Danny Byrd on 10/8/24.
//

import SwiftUI
import FirebaseAuth

class AuthManager: ObservableObject {
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
    @Published var errorMessage: String?

    init() {
        if isAuthenticated {
            if let id = Auth.auth().currentUser?.uid {
                Task {
                    do {
                        User.updateShared(user: try await FirebaseManager.fetchUserFromFirestore(uid: id))
                    } catch {
                        print("Fetch error: \(error)")
                    }
                }
            } else {
                print("Couldn't update user")
            }
            
        } else {
            print("User not authenticated")
        }
    }
    
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
    
    func signUp(email: String, password: String, user: User) async -> Bool {
        // Validate email and password are not empty
        guard !email.isEmpty, !password.isEmpty else {
            DispatchQueue.main.async {
                self.errorMessage = "Email and Password cannot be empty."
            }
            
            return false
        }

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            if let id = Auth.auth().currentUser?.uid {
                print("Uploading user")
                var didUpload = await FirebaseManager.addUserToFirebase(user: user)
                User.updateShared(user: user)
                print("DID UPLOAD: \(didUpload)")
            } else {
                print("User could not be UPLOADED")
            }
            DispatchQueue.main.async {
                self.isAuthenticated = true
                self.errorMessage = nil
            }
            return true
        } catch {
            print("error ISHUDSBISDBUSBD: \(error)")
            DispatchQueue.main.async {
                self.errorMessage = "Account creation failed"
            }
            
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
            print("FAILED SIGNOOUTTTTTT")
        }
    }
}
