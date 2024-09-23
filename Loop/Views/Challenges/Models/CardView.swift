//
//  CardView.swift
//  Loop
//
//  Created by joey on 9/23/24.
//

// CardView.swift
import SwiftUI

struct CardView: View {
    let challenge: Challenge  // Use Challenge instead of DailyScrum
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(challenge.title)  // Update to challenge.title
                .font(.headline)
            Spacer()
            HStack {
                Label("\(challenge.attendees.count)", systemImage: "person.3")
                Spacer()
                Label("\(challenge.lengthInMinutes)", systemImage: "clock")
                    .labelStyle(.trailingIcon)
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(challenge.theme.accentColor)  // Use challenge.theme.accentColor
    }
}

struct CardView_Previews: PreviewProvider {
    static var challenge = Challenge.sampleData[0]  // Use Challenge sample data
    static var previews: some View {
        CardView(challenge: challenge)  // Pass challenge to the preview
            .background(challenge.theme.mainColor)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
