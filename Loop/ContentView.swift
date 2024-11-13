//
//  ContentView.swift
//  Loop
//
//  Created by Max Ko on 9/13/24.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    init() {
        // Set the background color of UITabBar
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    @State var selectedView: TabSelection = .home
    @State private var userId: String? = nil
    var body: some View {
            TabView(selection: $selectedView) {
                if let userId = userId {
                    FeedView(userId: userId).tabItem {
                        Label("Home", systemImage: "house.fill")
                    }.tag(TabSelection.home)
                } else {
                    Text("Loading...").tabItem {
                        Label("Home", systemImage: "house.fill")
                    }.tag(TabSelection.home)
                }

                ChallengeListView().tabItem {
                    Label("Challenges", systemImage: "medal.fill")
                }.tag(TabSelection.challenges)

                RecordView().tabItem {
                    Label("Record", systemImage: "record.circle")
                        .foregroundColor(.red)
                }.tag(TabSelection.record)

                SelfProfileView().tabItem {
                    Label("Profile", systemImage: "person.fill")
                }.tag(TabSelection.profile)
            }
            .tint(.red)
            .onAppear {
                if let currentUser = Auth.auth().currentUser {
                    self.userId = currentUser.uid
                } else {
                    print("User not logged in")
                }
            }
        }
}

enum TabSelection {
    case home, challenges, profile, record
}

#Preview {
    ContentView()
}
