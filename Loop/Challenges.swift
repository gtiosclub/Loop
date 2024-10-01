//
//  Challenges.swift
//  Loop
//
//  Created by Rexxwell Tendean on 9/17/24.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

class Challenges {
    var challengeId: String = "";
    var challengeName: String;
    var challengeType: String; // Going to be an enum that will include different challenge types.
    var challengeStart: Date; // Think of a way to convert Date datatype to timestamp datatype in firebase.
    var challengeEnd: Date;
    var participants: [String] = []; // uids
    var host: String;
    
    init(challengeName: String, challengeType: String, challengeStart: Date, challengeEnd: Date, host: String) {
        self.challengeName = challengeName;
        self.challengeType = challengeType;
        self.challengeStart = challengeStart;
        self.challengeEnd = challengeEnd;
        self.host = host;
        participants.append(host);
    }
    
    // Adds a challenge to the firestore database.
    //
    // TODO: 1) add challenge id to the host challenges array.
    func addChallenge() async -> Void {
        // Create document's data
        let docData: [String: Any] = [
            "name" : challengeName,
            "type" : challengeType,
            "start" : Timestamp(date: challengeStart),
            "end" : Timestamp(date: challengeEnd),
            "participants" : participants,
            "host" : host
        ]
        
        // Initialize Cloud Firestore
        let db = Firestore.firestore();

        // Set a document
        do {
            let doc = db.collection("challenges").document();
            self.challengeId = doc.documentID;
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
        return "";
    }
}
