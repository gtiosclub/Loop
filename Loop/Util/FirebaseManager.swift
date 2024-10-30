//
//  FirebaseManager.swift
//  Loop
//
//  Created by Danny Byrd on 10/29/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class FirebaseManager {
    static let db = Firestore.firestore()
    
    static func addUserToFirebase(user: User) async -> Bool {
        guard let id = Auth.auth().currentUser?.uid else {
            return false
        }
        do {
            try await db.collection("users").document(id).setData([
                "uid": user.uid,
                "name": user.name,
                "username": user.username,
                "challengeIds": user.challengeIds,
                "profilePictureId": user.profilePictureId,
                "friends": user.friends,
                "incomingRequest": user.incomingRequest
            ])
            
            return true
        } catch {
            return false
        }
    }
    
    enum FirestoreFetchError: Error {
        case InvalidDataError(message: String)
        case InvalidDocumentError(message: String)
    }
    
    static func fetchUserFromFirestore(uid: String) async throws -> User {
        let docRef = db.collection("users").document(uid)
        
        do {
            let document = try await docRef.getDocument()
            if document.exists {
                let data = document.data()
                
                guard let data else {
                    print("Error with data!")
                    throw FirestoreFetchError.InvalidDataError(message: "Data of document was null")
                }
                
                let user = User(
                    uid: uid,
                    name: data["name"] as? String ?? "No name found",
                    username: data["username"] as? String ?? "No username found",
                    challengeIds: data["challengeIds"] as? [String] ?? [],
                    profilePictureId: data["profilePictureId"] as? String ?? "No profilePictureId found",
                    friends: data["friends"] as? [String] ?? [],
                    incomingRequest: data["incomingRequest"] as? [String] ?? []
                )
                
                print("Document data: \(data.debugDescription)")
                return user
            } else {
                print("Document does not exist")
                throw FirestoreFetchError.InvalidDocumentError(message: "Document does not exist")
            }
        } catch {
            print("Error getting document: \(error)")
            throw error
        }
    }
}
