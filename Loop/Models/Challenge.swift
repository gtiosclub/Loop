//
//  Challenge.swift
//  Loop
//
//  Created by joey on 9/23/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct Challenge: Identifiable {  // Previously DailyScrum
    var id: String = ""
    var title: String
    var attendees: [String]
    var lengthInMinutes: Int
    var theme: Theme
    var challengeType: String
    var dataMeasured: String
    var dateCreated: Date = .now
    var endDate: Date
    var host: String
    
    init(id: String = UUID().uuidString, title: String, attendees: [String], lengthInMinutes: Int, theme: Theme, endDate: Date, challengeType: String, dataMeasured: String, dateCreated: Date, host: String) {
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
        
        self.attendees.append(host)
    }
    
    // Adds a challenge to the firestore database.
    //
    // TODO: 1) add challenge id to the host challenges array.
    mutating func addChallenge() async  {
        // Create document's data
        let docData: [String: Any] = [
            "name" : title,
            "type" : challengeType,
            "start" : Timestamp(date: dateCreated),
            "end" : Timestamp(date: endDate),
            "participants" : attendees,
            "host" : host,
            "lengthInMinutes": lengthInMinutes,
            "dataMeasured": dataMeasured,
            "theme": theme.rawValue
        ]
        
        // Initialize Cloud Firestore
        let db = Firestore.firestore();

        // Set a document
        do {
            let doc = db.collection("challenges").document();
            id = doc.documentID;
            try await doc.setData(docData);
            print("Document succesfully written.");
        } catch {
            print("Error writing document: \(error).");
        }
    }
    
    // Retrieve the challenge details from the firestore database.
    func getChallenge(_ challengeId: String) async -> String {
        // Initialize Cloud Firestore
        let db = Firestore.firestore();
        
        // Get a document
        let docRef = db.collection("challenges").document(challengeId);
        do {
            let document = try await docRef.getDocument();
            if document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil";
                print ("Document data: \(dataDescription).");
                return dataDescription;
            } else {
                return "Document does not exist.";
            }
        } catch {
            return "Error getting document: \(error)";
        }
    }
    
    // Remove a challenge from the firestore database.
    func removeChallenge(_ challengeId: String) async -> String {
        let db = Firestore.firestore();
        let docRef = db.collection("challenges").document(challengeId);
        do {
            try await docRef.delete();
            return "\(challengeId) removed.";
        } catch {
            return "Error getting document: \(error).";
        }
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
