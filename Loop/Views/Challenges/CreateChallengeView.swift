//
//  CreateChallengeView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct CreateChallengeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var challengeName: String = ""
    @State private var challengeType: ChallengeType = .mostMilesRan
    @State private var endDate: Date = Date()
    
    
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
                .bold()
        }
        //Challenge Name (text input)
        TextField("Enter your challenge name.", text: $challengeName)
        //Challenge Type (dropdown)
        Picker("Challenge Type", selection: $challengeType) {
            Text("Most Miles Ran").tag(ChallengeType.mostMilesRan)
            Text("Most Calories Burned").tag(ChallengeType.mostCaloriesBurned)
            Text("Fastest Single Mile").tag(ChallengeType.fastestMile)
            Text("Most Consecutive Days Exercised").tag(ChallengeType.mostConsecutiveDays)
            Text("Farthest Distance Ran").tag(ChallengeType.farthestDistance)
        }
        //End Date (date picker)
        DatePicker("End Date", selection: $endDate, in: Date.now..., displayedComponents: .date)
        //Participants, with add participant (search list)
        Text("Participants")
    }
}

enum ChallengeType: String, CaseIterable, Identifiable {
    var id: Self {self}
    case mostMilesRan
    case mostCaloriesBurned
    case fastestMile
    case mostConsecutiveDays
    case farthestDistance
}

#Preview {
    CreateChallengeView()
}
