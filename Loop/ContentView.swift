//
//  ContentView.swift
//  Loop
//
//  Created by Max Ko on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    init() {
        // Set the background color of UITabBar
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    @State var selectedView: TabSelection = .home
    var body: some View {
        TabView(selection: $selectedView,
            content: {
            
            FeedView().tabItem {
                Label("Home", systemImage: "house.fill")
            }.tag(TabSelection.home)
            
            ChallengeListView(challenges: Challenge.sampleData).tabItem {
                Label("Challenges", systemImage: "figure.run")
            }.tag(TabSelection.challenges)
            
            RecordView().tabItem {
                Label("Record", systemImage: "clock.fill")
            }.tag(TabSelection.record)
            
            SelfProfileView().tabItem {
                Label("Profile", systemImage: "person.crop.circle.fill")
            }.tag(TabSelection.profile)
            
            
            }
        )
    }
}

enum TabSelection {
    case home, challenges, profile, record
}

#Preview {
    ContentView()
}
