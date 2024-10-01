//
//  User.swift
//  Loop
//
//  Created by Adil Husain on 9/26/24.



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
}
