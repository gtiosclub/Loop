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
class Challenge: Identifiable, ObservableObject {  // Previously DailyScrum
    @Published var id: String = ""
    @Published var title: String
    @Published var host: String
    @Published var attendees: [String]
    @Published var challengeType: String
    @Published var lengthInMinutes: Int
    @Published var dataMeasured: String
    @Published var dateCreated: Date = .now
    @Published var endDate: Date
    @Published var theme: Theme
    @Published var accessCode: String
    @Published var scores: [String: Double]
    @Published var attendeesFull = [Person]()
    
    ///full initializer
    init(id: String = "",
         title: String,
         host: String,
         attendees: [String],
         challengeType: String,
         lengthInMinutes: Int,
         dataMeasured: String,
         dateCreated: Date = .now,
         endDate: Date,
         theme: Theme,
         accessCode: String,
         scores: [String: Double]) {
            self.id = id
            self.title = title
            self.host = host
            self.attendees = attendees
            self.challengeType = challengeType
            self.lengthInMinutes = lengthInMinutes
            self.dataMeasured = dataMeasured
            self.dateCreated = dateCreated
            self.endDate = endDate
            self.theme = theme
            self.accessCode = accessCode
            self.scores = scores
        }
    
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
        id = UUID().uuidString
        self.title = title
        self.host = host
        self.attendees = attendees
//        self.attendees.append(host)
        self.challengeType = challengeType
        self.lengthInMinutes = lengthInMinutes
        self.dataMeasured = dataMeasured
        self.endDate = endDate
        self.theme = theme
        self.accessCode = ""
        self.scores = [:]
    }
    
    /// Convenience challenge initializer.
    ///
    /// - Parameter title: The title of the challenge.
    /// - Parameter host: The user uid of the host of the challenge.
    /// - Parameter challengeType: The type of the challenge.
    /// - Parameter lengthInMinutes: How long the challenge will last for. (?)
    /// - Parameter dateMeasured: The data measured in the challenge. (?)
    /// - Parameter endDate: The date when the challenge will end.
    convenience init(title: String, host: String, challengeType: String, lengthInMinutes: Int, dataMeasured: String, endDate: Date) {
        self.init(title: title, host: host, attendees: [], challengeType: challengeType, lengthInMinutes: lengthInMinutes, dataMeasured: dataMeasured, endDate: endDate, theme: Theme.bubblegum)
    }
    
    /// Adds a challenge to the Firestore Database.
    ///
    /// - Returns: The challenge id of the challenge in the Firestore Database, otherwise nil.
    // TODO: 1) Add challenge id to the host's challengeIds.
    // TODO:    Solution: Have to change host to User type so that
    // TODO:              we can access the host's challengeIds and append it.
    func addChallenge() async -> String? {
        let docData: [String: Any] = [
            "name" : title,
            "type" : challengeType,
            "start" : Timestamp(date: dateCreated),
            "end" : Timestamp(date: endDate),
            "attendees" : attendees,
            "host" : host,
            "lengthInMinutes": lengthInMinutes,
            "dataMeasured": dataMeasured,
            "theme": theme.rawValue,
            "accessCode": accessCode,
            "scores" : [host: 0]
        ]
        let db = Firestore.firestore();
        do {
            let doc = db.collection("challenges").document();
            id = doc.documentID;
            try await doc.setData(docData);
            print("Added challenge to the Firestore Database.");

            do {
                let docUserRef = db.collection("users").document(host)
                let documentUser = try await docUserRef.getDocument()
                if documentUser.exists {
                    if let dataDescription = documentUser.data() {
                        if let challengeIds = dataDescription["challengeIds"] {
                            var challengeIdsArray = challengeIds as! [String]
                            challengeIdsArray.append(id)
                            print("Added challenge id to user's challenge ids array.")
                            let docUserData: [String: Any] = [
                                "challengeIds": challengeIdsArray
                            ]
                            do {
                                try await docUserRef.setData(docUserData, merge: true)
                                print("Updated the user's challengeIds in the Firestore Database.")
                            } catch {
                                print ("Cannot update the user's data in the Firestore Database.")
                            }
                        }
                    }
                } else {
                    print("The user's uid does not exist in the Firestore Database.")
                }
            } catch {
                print("Cannot access the user's document in the Firestore Database.")
            }
            
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
    
    /// Get time left before a challenge ends in a string
    static func timeRemaining(endDate: Date) -> String {
        
        let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.day, .hour, .minute]
            formatter.unitsStyle = .abbreviated
            formatter.zeroFormattingBehavior = .pad

            if let timeDifference = formatter.string(from: Date(), to: endDate) {
                return timeDifference
            } else {
                return "N/A"
            }
    }
    
    //Get date range formatted in form MMM d, e.g. Oct 10 - Nov 11
    static func dateRange(start: Date, end: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        let startDateString = dateFormatter.string(from: start)
        let endDateString = dateFormatter.string(from: end)
            
        return "\(startDateString) - \(endDateString)"
    }
    
}

extension Challenge {
    static var sampleData: [Challenge] {
        let calendar = Calendar.current
        let date1 = calendar.date(from: DateComponents(year: 2024, month: 12, day:16))
        let date2 = calendar.date(from: DateComponents(year: 2024, month: 11, day:29))
        let date3 = calendar.date(from: DateComponents(year: 2024, month: 12, day:25))
        
        return [
            Challenge(title: "iOS Run Club", host: "Danny", attendees: ["Cathy", "Daisy", "Simon", "Jonathan"], challengeType: "Running", lengthInMinutes: 10, dataMeasured: "Miles", endDate: date1 ?? Date(), theme: .yellow),
            Challenge(title: "CoC Challenges", host: "Gray", attendees: ["Katie", "Gray", "Euna", "Luis", "Darla"], challengeType: "Hiking", lengthInMinutes: 5, dataMeasured: "Calories", endDate: date2 ?? Date(), theme: .orange),
            Challenge(title: "Joey vs Jason vs John", host: "Joey", attendees: ["Joey", "John", "Jason"], challengeType: "Biking", lengthInMinutes: 5, dataMeasured: "Time", endDate: date3 ?? Date(), theme: .purple)
        ]
    }
}
