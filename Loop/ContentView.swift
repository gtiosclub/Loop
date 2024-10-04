//
//  ContentView.swift
//  Loop
//
//  Created by Max Ko on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedView: TabSelection = .home
    var user1 = User(uid: "user1", name: "Rexxwell", profilePictureId: "Profile picture 1")
    var user2 = User(uid: "user2", name: "Danny", profilePictureId: "Profile picture 2")
    @State var challenge1 = Challenge(title: "Challenge 1", host: "user1", challengeType: "Cardio", lengthInMinutes: 5, dataMeasured: "Calories burned", endDate: .distantFuture)
    @State var challenge2 = Challenge(title: "Challenge 2", host: "user2", challengeType: "Weight Lifting", lengthInMinutes: 60, dataMeasured: "One rep max", endDate: .distantFuture)
    
    var body: some View {
        VStack {
            Button("Add users") {
                Task {
                    await user1.addUser()
                    await user2.addUser()
                }
            }
            Button("Get users") {
                Task {
                    await user1.getUser(uid: user1.uid)
                    await user2.getUser(uid: user2.uid)
                }
            }
            Button("Send friend request") {
                Task {
                    await user1.sendFriendRequest(otherUser: user2)
                }
            }
            Button("Accept friend request") {
                Task {
                    await user2.acceptFriendRequest(otherUser: user1)
                }
            }
            Button("Decline friend request") {
                Task {
                    await user2.declineFriendRequest(otherUser: user1)
                }
            }
            Button("Add Challenges") {
                Task {
                    await challenge1.addChallenge()
                    await challenge2.addChallenge()
                }
            }
            Button("Get Challenges") {
                Task {
                    await challenge1.getChallenge(challengeId: challenge1.id)
                    await challenge2.getChallenge(challengeId: challenge2.id)
                }
            }
            Button("Users participates in a challenge") {
                Task {
                    await challenge1.addChallenge()
                    await challenge2.addChallenge()
                    await user2.addChallenge(challenge: challenge1)
                    await user1.addChallenge(challenge: challenge2)
                }
            }
        }
    }
}

enum TabSelection {
    case home, challenges, profile
}

#Preview {
    ContentView()
}

