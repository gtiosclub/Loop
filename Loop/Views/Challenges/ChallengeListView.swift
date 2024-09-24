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
                NavigationLink(destination: ChallengeView()) {
                    Text("Challenge View ->")
                }
            }
        }
    }
}

#Preview {
    ChallengeListView()
}
