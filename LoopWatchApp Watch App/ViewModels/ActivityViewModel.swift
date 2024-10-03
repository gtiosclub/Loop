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

    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        //TODO: if let data = applicationContext["lists"] as? Data {
            do {
                // lists = try JSONDecoder().decode([ItemList].self, from: data)
                print("Data received from iPhone")
            } catch {
                print("Failed to decode data from iPhone: \(error)")
            }
        }
    }

    // Delegate Methods
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate()
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}

    //TODO: will maybe need later
    // private func sendUpdatedListsToPhone() {
    //     if WCSession.default.isReachable {
    //         do {
    //             let data = try JSONEncoder().encode(lists)
    //             let applicationContext: [String: Any] = ["lists": data]
    //             try WCSession.default.updateApplicationContext(applicationContext)
    //             print("Data sent to iPhone")
    //         } catch {
    //             print("Failed to send data to iPhone: \(error)")
    //         }
    //     }
    // }


    
    