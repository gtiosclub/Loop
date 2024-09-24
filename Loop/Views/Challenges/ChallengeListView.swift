//
//  ChallengeListView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct ChallengeListView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Challenge List View")
                NavigationLink(destination: ChallengeView(challenge: "Challenge Name", description: "Challenge Description", dateRange: "6/1 - 9/1")) {
                    Text("Challenge View ->")
                }
            }
        }
    }
}

#Preview {
    ChallengeListView()
}
