//
//  ChallengeListView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct ChallengeListView: View {
    @State private var isCreateChallengeActive = false
    let challenges: [Challenge] 
    var body: some View {
        NavigationStack {
            VStack {
                List(challenges, id: \.id) { challenge in
                    CardView(challenge: challenge)
                        .listRowBackground(challenge.theme.mainColor)
                }
            }
            .navigationTitle("Challenges")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isCreateChallengeActive = true
                    }) {
                        Image(systemName: "plus")
                            .accessibilityLabel("Add New Challenge")
                    }
                }
            }
            .navigationDestination(isPresented: $isCreateChallengeActive) {
                CreateChallengeView()
            }
        }
    }
}

#Preview {
    ChallengeListView(challenges: Challenge.sampleData)
}
