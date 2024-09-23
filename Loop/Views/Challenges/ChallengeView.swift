//
//  ChallengeView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct ChallengeView: View {
    
    var body: some View {
        ChallengeListView(challenges: Challenge.sampleData)
    }
}

#Preview {
    ChallengeView()
}
