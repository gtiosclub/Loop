//
//  ProfileViewModel.swift
//  Loop
//
//  Created by Jihoon Kim on 11/10/24.
//

import SwiftUI
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    var user = User(uid: "String", name: "String", username: "String", challengeIds: ["String"], profilePictureId: "String", friends: ["String"], incomingRequest: ["String"])
    @Published var friends: [Friend] = []
    var friendIs: [String] = []
    @Published var users: [Users] = []
    private let db = Firestore.firestore()
    
    struct Friend: Identifiable {
        let id: String
        let name: String
        let avatar: String
    }
    
    struct Users: Identifiable {
        let id: String
        let name: String
        let avatar: String
    }
    
    func getUserInfo(userId: String) async -> User? {
        return await user.getUser(uid: userId)
    }
    func getName(userId: String) async -> String? {
        return await getUserInfo(userId: userId)?.name
    }
    func addFriend(userId: String, friendId: String) async -> Void{
        let user = await getUserInfo(userId: userId)
        let friend = (await getUserInfo(userId: friendId))!
        await user?.sendFriendRequest(otherUser: friend)
    }
    func acceptFriend(userId: String, friendId: String) async -> Void {
        let user = await getUserInfo(userId: userId)
        let friend = (await getUserInfo(userId: friendId))!
        await user?.acceptFriendRequest(otherUser: friend)
    }
    func declineFriend(userId: String, friendId: String) async -> Void {
        let user = await getUserInfo(userId: userId)
        let friend = (await getUserInfo(userId: friendId))!
        await user?.declineFriendRequest(otherUser: friend)
    }
    
    func fetchFriendInfo(userId: String) async -> [String]? {
        let user = await getUserInfo(userId: userId)
        return user?.friends
    }
    
    public func fetchFriends(userId: String) -> Void{
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                if let friendIds = document.data()?["friends"] as? [String] {
                    for friendId in friendIds {
                        if !((self?.friendIs.contains(friendId)) == nil) {
                            self!.friendIs.append(friendId)
                            self?.fetchFriend(friendId)
                        }
                    }
                } else {
                    print("No friends found for user \(userId).")
                }
            } else {
                print("Error fetching user document: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    private func fetchFriend(_ friendId: String) {
        // Check if the friend is already in the friends array
        guard !friends.contains(where: { $0.id == friendId }) else {
            print("Friend with id \(friendId) is already in the friends list.")
            return
        }

        db.collection("users").document(friendId).getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["name"] as? String ?? "Unknown"
                let avatar = data?["avatar"] as? String ?? "person.crop.circle"
                
                let friend = Friend(id: friendId, name: name, avatar: avatar)
                DispatchQueue.main.async {
                    self?.friends.append(friend)
                }
            }
        }
    }

    public func fetchAllUsers() {
        db.collection("users").getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Error getting users: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("No users found")
                return
            }
            
            var users: [Users] = self?.users ?? []  // Start with the existing users, if any
            
            for document in snapshot.documents {
                let userId = document.documentID
                let name = document.data()["name"] as? String ?? "Unknown"
                let avatar = document.data()["avatar"] as? String ?? "person.crop.circle"
                
                // Check if the user is already in the users array
                if !users.contains(where: { $0.id == userId }) {
                    let user = Users(id: userId, name: name, avatar: avatar)
                    users.append(user)
                }
            }
            
            // Update the users array on the main thread
            DispatchQueue.main.async {
                self?.users = users  // Assuming `users` is a property of type [Users]
            }
        }
    }


    func fetchAllUsersExcludingFriends(for userId: String) {
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                if let friends = document.data()?["friends"] as? [ProfileViewModel.Friend] {
                    // Fetch all users except the friends
                    self?.fetchUsersExcludingFriends(friends)
                }
            } else {
                print("User document does not exist")
            }
        }
    }
    private func fetchUsersExcludingFriends(_ friends: [Friend]) {
        db.collection("users").getDocuments { [weak self] (snapshot, error) in
            if let error = error {
                print("Error getting users: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("No users found")
                return
            }
            
            var users: [Users] = []
            
            for document in snapshot.documents {
                let userId = document.documentID
                // Skip adding the user if they are in the friends array (by ID)
                if !friends.contains(where: { $0.id == userId }) {
                    let name = document.data()["name"] as? String ?? "Unknown"
                    let avatar = document.data()["avatar"] as? String ?? "person.crop.circle"
                    
                    let user = Users(id: userId, name: name, avatar: avatar)
                    users.append(user)
                }
            }
            
            // Do something with the users array, like updating the UI
            DispatchQueue.main.async {
                self?.users = users  // Assuming `users` is a property of type [User]
            }
        }
    }
}
