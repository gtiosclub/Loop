//
//  ContentView.swift
//  Loop
//
//  Created by Max Ko on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    @State var selectedView: TabSelection = .home
    var body: some View {
        TabView(selection: $selectedView,
            content: {
                HomeView().tabItem {
                    Label("Home", systemImage: "house.fill")
                }.tag(TabSelection.home)
            
                ChallengeListView().tabItem {
                Label("Challenges", systemImage: "figure.run")
            }.tag(TabSelection.challenges)
            
            SelfProfileView().tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }.tag(TabSelection.profile)
            }
        )
    }
}

enum TabSelection {
    case home, challenges, profile
}

#Preview {
    ContentView()
}
