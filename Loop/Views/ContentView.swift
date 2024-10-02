//
//  ContentView.swift
//  Loop
//
//  Created by Max Ko on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedView: TabSelection = .home
    var user1 = User(uid: "user1", name: "Rexxwell", challengeIds: [], profilePictureId: "Profile Picture", friends: [], incomingRequest: []);
    var user2 = User(uid: "user2", name: "Danny", challengeIds: [], profilePictureId: "Profile Picture", friends: [], incomingRequest: []);
    var body: some View {
        TabView(selection: $selectedView,
            content: {
                HomeView().tabItem {
                    Label("Home", systemImage: "house.fill")
                }.tag(TabSelection.home)
            
            ChallengeListView(challenges: Challenge.sampleData).tabItem {
                Label("Challenges", systemImage: "figure.run")
            }.tag(TabSelection.challenges)
            
            SelfProfileView().tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }.tag(TabSelection.profile)
            }
        )
        VStack {
            Button("Add user") {
                Task {
                    await print(user1.addUser())
                    await print(user2.addUser())
                }
            }
            Button("Get user") {
                Task {
                    await print(user1.getUser(uid: user1.uid))
                    await print(user2.getUser(uid: user2.uid))
                }
            }
            Button("Send friend request") {
                Task {
                    await print(user1.sendFriendRequest(otherUser: user2))
                }
            }
            Button("Accept friend request") {
                Task {
                    await print(user1.sendFriendRequest(otherUser: user2))
                    await print(user2.acceptFriendRequest(otherUser: user1))
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
