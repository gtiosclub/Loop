//
//  RecordViewModel.swift
//  Loop
//
//  Created by Joseph Masson on 11/6/24.
//

import Foundation
import WatchConnectivity

class RecordViewModel: NSObject, ObservableObject, WCSessionDelegate {
    // boolean from the watch to indicate if a workout is in progress
    @Published var workoutInProgress = false

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
    }

    //stub methods
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate")
        // Re-activate the session
        session.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let workoutStarted = message["workoutStarted"] as? Bool {
            DispatchQueue.main.async {
                self.workoutInProgress = workoutStarted
                print("Recieved message from watch: \(workoutStarted)")
            }
        }
    }
}
