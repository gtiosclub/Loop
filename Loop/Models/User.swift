//
//  User.swift
//  Loop
//
//  Created by Adil Husain on 9/26/24.

import FirebaseCore
import FirebaseFirestore

// TODO: 1) Change challengeIds to challenges instead with [Challenge] type.
// TODO: 2) Change friends to [User] type.
// TODO: 3) Change incomingRequest to [User] type.
// TODO: 4) Implement a removeChallenge() method so that the user can
// TODO:    can remove a challenge from the challengeIds.
class User: ObservableObject {
    static var shared = User(uid: "", name: "", username: "", challengeIds: [], profilePictureId: "", friends: [], incomingRequest: [])
    
    var uid: String
    var name: String
    var username: String
    var challengeIds: [String]
    var profilePictureId: String
    var friends: [String]
    var incomingRequest: [String] = []
    
    /// Designated user initializer.
    ///
    /// - Parameter uid: The uid of the user.
    /// - Parameter name: The name of the user.
    /// - Parameter challengeIds: The challenge id(s) of the challenge(s) the user has participated or hosted.
    /// - Parameter profilePictureId: The profile picture id of the user.
    /// - Parameter friends: The user id(s) of the friends the user has.
    init(uid: String, name: String, username: String, challengeIds: [String], profilePictureId: String, friends: [String], incomingRequest: [String]) {
        self.uid = uid
        self.name = name
        self.username = username
        self.challengeIds = challengeIds
        self.profilePictureId = profilePictureId
        self.friends = friends
        self.incomingRequest = incomingRequest
    }
    
    /// Convenience user initializer.
    ///
    /// - Parameter uid: The uid of the user.
    /// - Parameter name: The name of the user
    /// - Parameter profilePictureId: The profile picture id of the user.
    convenience init(uid: String, name: String, username: String, profilePictureId: String) {
        self.init(uid: uid, name: name, username: username, challengeIds: [], profilePictureId: profilePictureId, friends: [], incomingRequest: [])
    }
    
    /// Convert User to a dictionary for Firestore storage
    ///
    /// - Returns: A dictionary of the user data for Firestore storage.
    func toDictionary() -> [String: Any] {
        return [
            "uid": uid,
            "name": name,
            "username": username,
            "challengeIds": challengeIds,
            "profilePictureId": profilePictureId,
            "friends": friends,
            "incomingRequest": incomingRequest
        ]
    }
    
    /// Add a user to the Firestore Database.
    ///
    /// - Returns: The uid of the user added to the Firestore Database, otherwise nil.
    func addUser() async -> String? {
        let db = Firestore.firestore()
        let docRef = toDictionary()
        do {
            let doc = db.collection("users").document(uid)
            try await doc.setData(docRef)
            print("Successfully added a user to the Firestore Database.")
            return uid
        } catch {
            print("Error adding user to Firestore database: \(error).")
        }
        return nil;
    }
    
    /// Get a user from the Firestore Database.
    ///
    /// - Parameter uid: The uid of the user.
    /// - Returns: A copy of the user instance from the Firebase Database, otherwise nil.
    // TODO: 1) getUser function return a User type instead of a String.
    // TODO:    a) Could implemenet this by manually copy and pasting the data found from firestore
    // TODO:       to a new User object and returning that.
    // TODO:    b) Could implement this by using a codable User type, which is more complex to do since
    // TODO:       we probably have to change the user interface.
    func getUser(uid: String) async -> User? {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)
        do {
          let document = try await docRef.getDocument()
          if document.exists {
              let dataDescription = document.data()
              if let data = dataDescription {
                  let name: String = data["name"] as! String
                  let username: String = data["username"] as! String
                  let challengeIds: [String] = data["challengeIds"] as! [String]
                  let profilePictureId: String = data["profilePictureId"] as! String
                  let friends: [String] = data["friends"] as! [String]
                  let incomingRequest: [String] = data["incomingRequest"] as! [String]
                  return User(uid: uid, name: name, username: username, challengeIds: challengeIds, profilePictureId: profilePictureId, friends: friends, incomingRequest: incomingRequest)
              } else {
                  print("User's data in Firestore Database is nil.")
              }
          } else {
              print("User does not exist in the Firestore Database.")
          }
        } catch {
            print("Error getting user from the Firestore Database: \(error).")
        }
        return nil
    }
    
    /// Sends a friend request to another user.
    ///
    /// If the other user's incoming request already contains this user,
    /// then say that friend request already sent.
    ///
    /// - Parameter otherUser: The other user object that you want to send a friend request to.
    /// - Returns: The user uid of the user that you sent the friend request to, otherise nil.
    func sendFriendRequest(otherUser: User) async -> String? {
        if (otherUser.incomingRequest.contains(uid)) {
            print("Friend request already sent.")
            return nil
        }
        if (friends.contains(otherUser.uid)) {
            print("Cannot send friend request to a user that is your friend")
            return nil
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
            return otherUser.uid
        } catch {
            print("Error updating the incoming request of other user on Firestore database: \(error).");
        }
        return nil
    }
    
    /// Accepts a friend request sent by another user.
    ///
    /// Remove otherUser.uid from self.incomingRequest and add it to self.friends.
    /// Updates the Firestore database of this user and other user.
    ///
    /// If otherUser.uid is not in self.incomingRequest, say that there
    /// was not any friend request sent by otherUser.
    ///
    /// - Parameter otherUser: The other user object that you want to accept the friend request to.
    /// - Returns: The user uid of the user that you accepted the friend request to, otherwise nil.
    func acceptFriendRequest(otherUser: User) async -> String? {
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
                    print("Updated the user data to Firestore database.")
                    return otherUser.uid
                } catch {
                    print("Error updating the user data to Firestore database: \(error).")
                }
            }
        } else {
            print("The user you want to accept as a friend did not send a friend request to you.")
        }
        return nil
    }
    
    /// User declines a friend request of another user.
    ///
    /// Updates the user's incomingRequest data to Firestore database.
    ///
    /// - Parameter otherUser: The other User object.
    /// - Returns: The user uid of the user you declined the friend request to, otherwise nil.
    func declineFriendRequest(otherUser: User) async -> String? {
        if (!incomingRequest.contains(otherUser.uid)) {
            // If the other user uid does not exist in this user's incoming request,
            // then say that you cannot decline a friend request that does not exist.
            print("Cannot decline a friend request that does not exist.")
            return nil
        }
        if let index = incomingRequest.firstIndex(of: otherUser.uid) {
            incomingRequest.remove(at: index)
            let db = Firestore.firestore()
            let docRefThisUser = db.collection("users").document(uid)
            let docDataThisUser: [String: Any] = [
                "incomingRequest": incomingRequest
            ]
            do {
                try await docRefThisUser.setData(docDataThisUser, merge: true)
                print("Successfully declined the friend request of the other user.")
                return otherUser.uid
            } catch {
                print("Error setting the new user data to the Firestore Database.")
            }
        }
        return nil
    }
    
    /// User adds a challenge to their challenge list.
    ///
    /// Updates the user's challengeIds and challenge's attendees to the Firestore database.
    ///
    /// - Parameter challenge: The Challenge object.
    /// - Returns: The challenge id of the challenge added, otherwise nil.
    func addChallenge(challenge: Challenge) async -> String? {
        if (uid == challenge.host) {
            print("Cannot add challenge that you created.")
            return nil
        }
        let challengeId = challenge.id
        challengeIds.append(challengeId)
        var attendees = challenge.attendees
        attendees.append(uid)
        let db = Firestore.firestore()
        let docRefUser = db.collection("users").document(uid)
        let docRefChallenge = db.collection("challenges").document(challengeId)
        let docDataUser: [String: Any] = [
            "challengeIds": challengeIds
        ]
        let docDataChallenge: [String: Any] = [
            "attendees": attendees
        ]
        do {
            try await docRefUser.setData(docDataUser, merge: true)
            try await docRefChallenge.setData(docDataChallenge, merge: true)
            print("Updated the user and challenge to the Firebase database.")
            return challenge.id
        } catch {
            print("Error updating the user and challenge to the Firebase database: \(error).")
        }
        return nil
    }
    
    static func updateShared(user: User) {
        DispatchQueue.main.async {
            shared.uid = user.uid
            shared.name = user.name
            shared.username = user.username
            shared.challengeIds = user.challengeIds
            shared.profilePictureId = user.profilePictureId
            shared.friends = user.friends
            shared.incomingRequest = user.incomingRequest
        }
    }
}
