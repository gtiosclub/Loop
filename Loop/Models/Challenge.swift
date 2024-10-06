//
//  Challenge.swift
//  Loop
//
//  Created by joey on 9/23/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

// TODO: 1) Change host type to User.
// TODO: 2) Change attendees type to [User].
struct Challenge: Identifiable {  // Previously DailyScrum
    var id: String = ""
    var title: String
    var host: String
    var attendees: [String]
    var challengeType: String
    var lengthInMinutes: Int
    var dataMeasured: String
    var dateCreated: Date = .now
    var endDate: Date
    var theme: Theme
    
    /// Designated challenge initializer.
    ///
    /// - Parameter title: The title of the challenge.
    /// - Parameter host: The user uid of the host of the challenge.
    /// - Parameter attendees: The user id(s) of the participants of the challenge.
    /// - Parameter challengeType: The type of the challenge.
    /// - Parameter lengthInMinutes: How long the challenge will last for. (?)
    /// - Parameter dataMeasured: The data measured in the challenge. (?)
    /// - Parameter endDate: The date when the challenge will end.
    /// - Parameter theme: The theme of the challenge. (?)
    init(title: String, host: String, attendees: [String], challengeType: String, lengthInMinutes: Int, dataMeasured: String, endDate: Date, theme: Theme) {
        self.title = title
        self.host = host
        self.attendees = attendees
        self.attendees.append(host)
        self.challengeType = challengeType
        self.lengthInMinutes = lengthInMinutes
        self.dataMeasured = dataMeasured
        self.endDate = endDate
        self.theme = theme
    }
    
    /// Convenience challenge initializer.
    ///
    /// - Parameter title: The title of the challenge.
    /// - Parameter host: The user uid of the host of the challenge.
    /// - Parameter challengeType: The type of the challenge.
    /// - Parameter lengthInMinutes: How long the challenge will last for. (?)
    /// - Parameter dateMeasured: The data measured in the challenge. (?)
    /// - Parameter endDate: The date when the challenge will end.
    init(title: String, host: String, challengeType: String, lengthInMinutes: Int, dataMeasured: String, endDate: Date) {
        self.init(title: title, host: host, attendees: [], challengeType: challengeType, lengthInMinutes: lengthInMinutes, dataMeasured: dataMeasured, endDate: endDate, theme: Theme.bubblegum)
    }
    
    /// Adds a challenge to the Firestore Database.
    ///
    /// - Returns: The challenge id of the challenge in the Firestore Database, otherwise nil.
    // TODO: 1) Add challenge id to the host's challengeIds.
    // TODO:    Solution: Have to change host to User type so that
    // TODO:              we can access the host's challengeIds and append it.
    mutating func addChallenge() async -> String? {
        let docData: [String: Any] = [
            "name" : title,
            "type" : challengeType,
            "start" : Timestamp(date: dateCreated),
            "end" : Timestamp(date: endDate),
            "attendees" : attendees,
            "host" : host,
            "lengthInMinutes": lengthInMinutes,
            "dataMeasured": dataMeasured,
            "theme": theme.rawValue
        ]
        let db = Firestore.firestore();
        do {
            let doc = db.collection("challenges").document();
            id = doc.documentID;
            try await doc.setData(docData);
            print("Added challenge to the Firestore Database.");
            return id;
        } catch {
            print("Error adding challenge to the Firestore Database: \(error).");
        }
        return nil;
    }
    
    /// Get the challenge data from the Firestore Database.
    ///
    /// - Parameter challengeId: The challenge id of the challenge data you want to get.
    /// - Returns: The challenge data from the Firestore Database, otherwise nil.
    func getChallenge(challengeId: String) async -> String? {
        let db = Firestore.firestore()
        let docRef = db.collection("challenges").document(challengeId)
        do {
            let document = try await docRef.getDocument()
            if document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("Successfully retrieved the challenge data from the Firestore Database.")
                return dataDescription
            } else {
                print("The challenge data with the given challenge id does not exist.")
            }
        } catch {
            print("Error retrieving the challenge data from the Firestore Database: \(error).")
        }
        return nil;
    }
    
    /// Remove a challenge from the Firestore Database.
    ///
    /// - Parameter challengeId: The challenge id of the challenge you want to remove.
    /// - Returns: The challenge id removed from the Firestore Database, otherwise nil.
    func removeChallenge(challengeId: String) async -> String? {
        let db = Firestore.firestore()
        let docRef = db.collection("challenges").document(challengeId)
        do {
            try await docRef.delete()
            print("Successfully removed the challenge data from the Firestore Database.")
            return challengeId;
        } catch {
            
            print("Error removing the challenge data from the Firestore Database: \(error).")
        }
        return nil;
    }
}

extension Challenge {
    static var sampleData: [Challenge] {
        [
            Challenge(title: "iOS Run Club", host: "Danny", attendees: ["Cathy", "Daisy", "Simon", "Jonathan"], challengeType: "Accumulation", lengthInMinutes: 10, dataMeasured: "Miles", endDate: .distantFuture, theme: .yellow),
            Challenge(title: "CoC Challenges", host: "Gray", attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"], challengeType: "Best rep", lengthInMinutes: 5, dataMeasured: "1 Mile", endDate: .distantFuture, theme: .orange),
            Challenge(title: "Joey vs Jason vs John", host: "Joey", attendees: ["Joey", "John", "Jason"], challengeType: "Accumulation", lengthInMinutes: 5, dataMeasured: "Calories Burned", endDate: .distantFuture, theme: .purple)
        ]
    }
}
