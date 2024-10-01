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
    var challengeType: String
    var dataMeasured: String
    var dateCreated: Date = .now
    var endDate: Date
    var host: String
    
    init(id: UUID = UUID(), title: String, attendees: [String], lengthInMinutes: Int, theme: Theme, endDate: Date, challengeType: String, dataMeasured: String, dateCreated: Date, host: String) {
        self.id = id
        self.title = title
        self.attendees = attendees
        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
        self.endDate = endDate
        self.host = host
        self.dateCreated = dateCreated
        self.challengeType = challengeType
        self.dataMeasured = dataMeasured
    }
}

extension Challenge {
    static var sampleData: [Challenge] {
        [
            Challenge(title: "iOS Run Club", attendees: ["Cathy", "Daisy", "Simon", "Jonathan"], lengthInMinutes: 10, theme: .yellow, endDate: .distantFuture, challengeType: "Accumulation", dataMeasured: "Miles", dateCreated: .now, host: "Danny"),
            Challenge(title: "CoC Challenges", attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"], lengthInMinutes: 5, theme: .orange, endDate: .distantFuture, challengeType: "Best rep", dataMeasured: "1 Mile", dateCreated: .now, host: "Gray"),
            Challenge(title: "Joey vs Jason vs John", attendees: ["Joey", "John", "Jason"], lengthInMinutes: 5, theme: .purple, endDate: .distantFuture, challengeType: "Accumulation", dataMeasured: "Calories Burned", dateCreated: .now, host: "Joey")
        ]
    }
}
