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
                "uid": id,
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
        case NoDocumentFoundError(message: String)
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
    
    
    // TODO: CANNOT JOIN SAME CHALLENGE MULTIPLE TIMES
    static func joinChallengeWithCode(_ code: String) async throws {
        let query = db.collection("challenges").whereField("accessCode", isEqualTo: code)
        let result = try await query.getDocuments()
        
        if result.isEmpty {
            throw FirestoreFetchError.NoDocumentFoundError(message: "No challenge has that access code")
        } else {
            guard let document = result.documents.first else {
                throw FirestoreFetchError.NoDocumentFoundError(message: "Failed to retrieve challenge document")
            }
            
            let data = document.data()
            
            var challenge = Challenge(
                id: document.documentID,
                title: data["title"] as? String ?? "",
                host: data["host"] as? String ?? "",
                attendees: data["attendees"] as? [String] ?? [],
                challengeType: data["challengeType"] as? String ?? "",
                lengthInMinutes: data["lengthInMinutes"] as? Int ?? 0,
                dataMeasured: data["dataMeasured"] as? String ?? "",
                dateCreated: (data["dateCreated"] as? Timestamp)?.dateValue() ?? Date(),
                endDate: (data["endDate"] as? Timestamp)?.dateValue() ?? Date(),
                theme: Theme(rawValue: data["theme"] as? String ?? "") ?? .bubblegum,
                accessCode: data["accessCode"] as? String ?? "",
                scores: data["scores"] as? [String: Double] ?? [:]
            )
            if !challenge.attendees.contains(User.shared.uid) {
                challenge.attendees.append(User.shared.uid)
                challenge.attendeesFull.append(Person(id: User.shared.uid, name: User.shared.username, score: 0))
            }
            
            _ = await User.shared.addChallenge(challenge: challenge)
        }
    }
}
