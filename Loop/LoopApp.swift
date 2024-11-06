import SwiftUI
import FirebaseCore
import HealthKit


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    // Request for HealthKit authorization
        HealthKitManager.shared.requestAuthorization { success, error in
            if success {
                print("HealthKit authorization granted.")
            } else {
                print("HealthKit authorization denied: \(String(describing: error))")
            }
        }

    return true
  }
}

// Manager for HealthKit permissions
class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()

    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }

        let readTypes: Set<HKObjectType> = [
            HKObjectType.workoutType()
        ]

        let writeTypes: Set<HKSampleType> = [
            HKObjectType.workoutType()
        ]
        //Error - Thread 1: "NSHealthUpdateUsageDescription must be set in the app's Info.plist in order to request write authorization for the following types: HKWorkoutTypeIdentifier"
        healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, error in
            completion(success, error)
        }
    }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var authManager = AuthManager()

  var body: some Scene {
    WindowGroup {
      NavigationView {
          if authManager.isAuthenticated {
              ContentView()
          } else {
              WelcomView()
          }
      }
      .environmentObject(authManager)
    }
  }
}
