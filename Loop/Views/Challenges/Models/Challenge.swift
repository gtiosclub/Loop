//
//  Challenge.swift
//  Loop
//
//  Created by joey on 9/23/24.
//

import Foundation

struct Challenge: Identifiable {  // Previously DailyScrum
    let id: UUID
    var title: String
    var attendees: [String]
    var lengthInMinutes: Int
    var theme: Theme
    
    init(id: UUID = UUID(), title: String, attendees: [String], lengthInMinutes: Int, theme: Theme) {
        self.id = id
        self.title = title
        self.attendees = attendees
        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
    }
}

extension Challenge {
    static var sampleData: [Challenge] {
        [
            Challenge(title: "iOS Run Club", attendees: ["Cathy", "Daisy", "Simon", "Jonathan"], lengthInMinutes: 10, theme: .yellow),
            Challenge(title: "CoC Challenges", attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"], lengthInMinutes: 5, theme: .orange),
            Challenge(title: "Joey vs Jason vs John", attendees: ["Joey", "John", "Jason"], lengthInMinutes: 5, theme: .purple)
        ]
    }
}
