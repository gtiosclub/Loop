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
    var description: String
    var attendees: [String]
    var lengthInMinutes: Int
    var theme: Theme
    
    init(id: UUID = UUID(), title: String, description: String, attendees: [String], lengthInMinutes: Int, theme: Theme) {
        self.id = id
        self.title = title
        self.description = description
        self.attendees = attendees
        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
    }
}

extension Challenge {
    static var sampleData: [Challenge] {
        [
            Challenge(title: "iOS Run Club", description: "Most Miles Ran", attendees: ["Cathy", "Daisy", "Simon", "Jonathan"], lengthInMinutes: 10, theme: .yellow),
            Challenge(title: "CoC Challenges", description: "Farthest Distance Ran", attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"], lengthInMinutes: 5, theme: .orange),
            Challenge(title: "Joey vs Jason vs John", description: "Most Calories Burned", attendees: ["Joey", "John", "Jason"], lengthInMinutes: 5, theme: .purple)
        ]
    }
}
