//
//  WatchConnectivityProvider.swift
//  Loopy
//
//  Created by Joseph Masson on 10/30/24.
//

import Foundation
import WatchConnectivity

protocol WatchConnectivityProviderDelegate: AnyObject {
    func didReceiveMessage(_ message: [String: Any])
}

class WatchConnectivityProvider: NSObject, WCSessionDelegate {
    
    #if os(iOS)
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        //code
        print("Hi")

    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        //code
        print("Hi")

    }
    #endif
    
    static let shared = WatchConnectivityProvider()
    weak var delegate: WatchConnectivityProviderDelegate?

    private override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    func sendMessage(_ message: [String: Any]) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
        }
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        DispatchQueue.main.async {
            self.delegate?.didReceiveMessage(message)
        }
    }

}
