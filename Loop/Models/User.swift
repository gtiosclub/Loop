//
//  User.swift
//  Loop
//
//  Created by Adil Husain on 9/26/24.

import FirebaseCore;
import FirebaseFirestore;

class User {
    var uid: String
    var name: String
    var challengeIds: [String]
    var profilePictureId: String
    var friends: [String]
    var incomingRequest: [String]
    
    init(uid: String, name: String, challengeIds: [String], profilePictureId: String, friends: [String], incomingRequest: [String]) {
        self.uid = uid
        self.name = name
        self.challengeIds = challengeIds
        self.profilePictureId = profilePictureId
        self.friends = friends
        self.incomingRequest = incomingRequest
    }
    
    
    // Convert User to a dictionary for Firestore storage
    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "name": name,
            "challengeIds": challengeIds,
            "profilePictureId": profilePictureId,
            "friends": friends,
            "incomingRequest": incomingRequest
        ]
    }
    
    // Add a user to the Firestore database.
    func addUser() async -> String {
        let db = Firestore.firestore()
        let docRef = toDictionary()
        do {
            let doc = db.collection("users").document(uid)
            try await doc.setData(docRef)
            print("Added user to Firestore database.")
            return uid
        } catch {
            return "Error adding user to Firestore database: \(error)."
        }
    }
    
    // Get a user from the Firestore database.
    func getUser(uid: String) async -> String {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)
        do {
          let document = try await docRef.getDocument()
          if document.exists {
            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
              return "Document data: \(dataDescription).";
          } else {
              return "Document does not exist."
          }
        } catch {
            return "Error getting document: \(error)."
        }
    }
    
    // Sends a friend request to another user.
    //
    // Add self.uid to otherUser.incomingRequest.
    // Updates the Firestore database of the other user.
    //
    // If the other user's incoming request already contains this user,
    // then say that friend request already sent.
    // Returns the updated incoming request array of the other user, otherwise
    // returns the current incoming request array of the other user.
    func sendFriendRequest(otherUser: User) async -> [String] {
        if (otherUser.incomingRequest.contains(uid)) {
            print("Friend request already sent.")
            return otherUser.incomingRequest
        }
        otherUser.incomingRequest.append(uid);
        let db = Firestore.firestore()
        let docData: [String : Any] = [
            "incomingRequest": otherUser.incomingRequest
        ]
        let docRef = db.collection("users").document(otherUser.uid);
        do {
            try await docRef.setData(docData, merge: true);
            print("Updated the incoming request of other user on Firestore database.")
        } catch {
            print("Error updating the incoming request of other user on Firestore database: \(error).");
        }
        return otherUser.incomingRequest;
    }
    
    // Accepts a friend request sent by another user.
    //
    // Remove otherUser.uid from self.incomingRequest and add it to self.friends.
    // Updates the Firestore database of this user and other user.
    //
    // If otherUser.uid is not in self.incomingRequest, say that there
    // was not any friend request sent by otherUser.
    // Returns the updated friends array of this user, otherwise
    // returns the current friends array of this user.
    func acceptFriendRequest(otherUser: User) async -> [String] {
        if (incomingRequest.contains(otherUser.uid)) {
            if let index = incomingRequest.firstIndex(of: otherUser.uid) {
                friends.append(incomingRequest.remove(at: index))
                otherUser.friends.append(uid)
                let db = Firestore.firestore()
                let docRefThisUser = db.collection("users").document(uid)
                let docRefOtherUser = db.collection("users").document(otherUser.uid)
                let docDataThisUser: [String : Any] = [
                    "incomingRequest": incomingRequest,
                    "friends": friends
                ]
                let docDataOtherUser: [String : Any] = [
                    "friends": otherUser.friends
                ]
                do {
                    try await docRefThisUser.setData(docDataThisUser, merge: true)
                    try await docRefOtherUser.setData(docDataOtherUser, merge: true)
                    print("Updated the data to Firestore database.")
                } catch {
                    print("Error updating data to Firestore database: \(error).")
                }
            }
        } else {
            print("\(otherUser.uid) did not send a friend request.")
        }
        return friends
    }
}
