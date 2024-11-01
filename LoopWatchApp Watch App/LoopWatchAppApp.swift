//
//  LoopWatchAppApp.swift
//  LoopWatchApp Watch App
//
//  Created by Matt Free on 9/26/24.
//
import SwiftUI
import HealthKit

// Manager for HealthKit permissions
class HealthKitManager {
    static let shared = HealthKitManager()
    let healthStore = HKHealthStore()
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }

        let readTypes: Set<HKObjectType> = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]

        let writeTypes: Set<HKSampleType> = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]

        healthStore.requestAuthorization(toShare: writeTypes, read: readTypes) { success, error in
            completion(success, error)
        }
    }
}

@main
struct LoopWatchApp_Watch_AppApp: App {
    // Request for HealthKit authorization
    init() {
        HealthKitManager.shared.requestAuthorization { success, error in
            if success {
                print("HealthKit authorization granted.")
            } else {
                print("HealthKit authorization denied: \(String(describing: error))")
            }
        }
    }
    //@StateObject var wk = WorkoutManager()
    // Initialize managers here
    @StateObject private var workoutManager = WorkoutManager.shared
    private let exercisesList = ExercisesList()

    var body: some Scene {
        WindowGroup {
            
            NavigationView {
                WatchTypesOfExerciseView()
            }
                .environmentObject(workoutManager)
                .environmentObject(exercisesList)
                .sheet(isPresented: $workoutManager.showingSummaryView) {
                    SummaryView()
                }
        }
    }
}
