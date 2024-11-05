//
//  FeedViewModel.swift
//  Loop
//
//  Created by Jason Nair on 9/17/24.
//

import SwiftUI
import FirebaseFirestore

class FeedViewModel: ObservableObject {
    @Published var friendPosts: [FriendPost] = []
    private let db = Firestore.firestore()
    
    func fetchFriendPosts(for userId: String) {
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                if let friends = document.data()?["friends"] as? [String] {
                    for friendId in friends {
                        self?.fetchPostForFriend(friendId)
                    }
                }
            } else {
                print("User document does not exist")
            }
        }
    }
    
    private func fetchPostForFriend(_ friendId: String) {
        db.collection("users").document(friendId).getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let name = data?["name"] as? String ?? "Unknown"
                let avatar = data?["avatar"] as? String ?? "person.crop.circle"
                
                if let post = data?["Post"] as? String {
                    let newPost = FriendPost(id: friendId, name: name, avatar: avatar, content: post, date: "Temp Time: Today")
                    DispatchQueue.main.async {
                        self?.friendPosts.append(newPost)
                    }
                }
            }
        }
    }
}

struct FriendPost {
    let id: String
    let name: String
    let avatar: String
    let content: String
    let date: String
}

