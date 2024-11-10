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
                    Label("Challenges", systemImage: "figure.run")
                }.tag(TabSelection.challenges)

                RecordView().tabItem {
                    Label("Record", systemImage: "clock.fill")
                }.tag(TabSelection.record)

                SelfProfileView().tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }.tag(TabSelection.profile)
            }
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
