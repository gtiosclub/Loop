import Combine
import SwiftUI
import WatchConnectivity

final class ActivityViewModel: ObservableObject, WCSessionDelegate {
    @Published var activity: Activity
    
    private var cancellables = Set<AnyCancellable>()
    private var session: WCSession?


    init(activity: Activity) {
        self.activity = activity
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
            print("Session Activated on iPhone")
        }
    }

    private func sendDataToWatch() {
        guard let session = session, session.isPaired, session.isWatchAppInstalled else { return }
        do {
            print("Sending data to watch")
            //TODO: let data = try JSONEncoder().encode(lists)
            try session.updateApplicationContext(["lists": data])
            print("Data sent to watch")
        } catch {
            print("Failed sending data: \(error)")
        }
    }

    // Delegate Methods
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}



    
    