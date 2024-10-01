//
//  CardView.swift
//  Loop
//
//  Created by joey on 9/23/24.
//

import SwiftUI

struct CardView: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(challenge.title)
                .font(.headline)
            Spacer()
            HStack {
                Label("\(challenge.attendees.count)", systemImage: "person.3")
                Spacer()
                Label("\(challenge.lengthInMinutes)", systemImage: "clock")
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(challenge.theme.accentColor)
    }
}

struct CardView_Previews: PreviewProvider {
    static var challenge = Challenge.sampleData[0]
    static var previews: some View {
        CardView(challenge: challenge)
            .background(challenge.theme.mainColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
