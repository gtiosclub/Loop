//
//  WorkoutManager.swift
//  Loop
//
//  Created by Joseph Masson on 10/23/24.
//

import HealthKit
import SwiftUI
import os
import WatchConnectivity

class WorkoutManager: NSObject, ObservableObject, WCSessionDelegate {
    //Ignore all of the if-else OS blocks - iOS doesn't support a lot of these HK methods
    // but it needs to see this class to compile.

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print("Session started from Watch")
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        //stub method
        print("Session Became Inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //stub method
        print("Session Deactivated")
    }
    #endif
    
    @Published var isRunning = false
    @Published var isPaused = false
    @Published var distance = 0.0  // Distance in meters
    @Published var calories = 0.0  // Calories in kcal
    @Published var isWorkoutInProgress = false
    
    static let shared = WorkoutManager()
    private let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?

    #if os(watchOS)
    private var builder: HKLiveWorkoutBuilder?
    #endif

    // Init the WC session
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func startWorkout() {
        #if os(watchOS)
        distance = 0
        calories = 0
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .running
        configuration.locationType = .outdoor

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()

            session?.delegate = self
            builder?.delegate = self

            builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

            session?.startActivity(with: Date())
            builder?.beginCollection(withStart: Date(), completion: { (success, error) in
                DispatchQueue.main.sync {
                    self.isRunning = true
                    self.isPaused = false
                    // communication variables
                    self.isWorkoutInProgress = true
                    self.sendWorkoutStartedMessage()
                    print("Successfully started workout")
                }
            })
            
        } catch {
            print("Failed to start workout: \(error.localizedDescription)")
        }
        #endif
    }

    // Functions to send the boolean via WC
    private func sendWorkoutStartedMessage() {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["workoutStarted": true], replyHandler: nil, errorHandler: { error in
                print("Error sending message: \(error.localizedDescription)")
            })
            print("Message sent")
        } else {
            print("Session is not reachable")
        }
    }

    private func sendWorkoutEndedMessage() {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["workoutStarted": false], replyHandler: nil, errorHandler: { error in
                print("Error sending message: \(error.localizedDescription)")
            })
            print("Message sent")
        } else {
            print("Session is not reachable")
        }
    }

    func pauseWorkout() {
        #if os(watchOS)
        guard let session = session else { return }
        
        if session.state == .running {
            session.pause()
            DispatchQueue.main.async {
                print("Session paused on Queue")
                self.isPaused = true
                self.isRunning = false
            }
        }
        #endif
    }
    
    func resumeWorkout() {
        #if os(watchOS)
        guard let session = session else { return }

        if session.state == .paused {
            session.resume()
            DispatchQueue.main.async {
                print("Session resumed on Queue")
                self.isPaused = false
                self.isRunning = true
            }
        }
        #endif
    }

    
    func endWorkout() {
        #if os(watchOS)
        guard let session = session, let builder = builder else { return }

        // First, end the session
        session.end()

        // Then, end the data collection
        builder.endCollection(withEnd: Date()) { success, error in
            if success {
                self.builder?.finishWorkout(completion: { (finalWorkout, error) in
                    if let error = error {
                        print("Error finishing workout: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            self.isWorkoutInProgress = false
                        }
                        print("Workout successfully finished!")
                    }
                })
            } else if let error = error {
                print("Error ending workout collection: \(error.localizedDescription)")
            }
        }

        // Update iPhone app
        self.sendWorkoutEndedMessage()

        #endif
    }

}

#if os(watchOS)
extension WorkoutManager: HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    //this manager needs a lot of stubs
    
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        #if os(watchOS)
        if toState == .ended {
            builder?.endCollection(withEnd: date, completion: { (success, error) in
                self.builder?.finishWorkout(completion: { (workout, error) in
                    DispatchQueue.main.async {
                        self.isPaused = false
                        self.isRunning = false
                        print("Successfully ended workout")
                    }
                })
            })
        }
        #endif
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        #if os(watchOS)
        print("Workout session failed: \(error.localizedDescription)")
        #endif
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // handles workout events if needed
    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        #if os(watchOS)
        // Handle collected data if needed
        for type in collectedTypes {
            if let quantityType = type as? HKQuantityType {
                
                // Track distance traveled
                if quantityType == HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) {
                    if let distance = workoutBuilder.statistics(for: quantityType)?.sumQuantity() {
                        DispatchQueue.main.sync {
                            let distanceInYards = distance.doubleValue(for: HKUnit.mile())
                            print("Distance: \(distanceInYards) yards")
                            self.distance = distanceInYards
                        }
                    }
                }
                
                // Track active calories burned
                if quantityType == HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) {
                    if let calories = workoutBuilder.statistics(for: quantityType)?.sumQuantity() {
                        DispatchQueue.main.sync {
                            let caloriesInKilocalories = calories.doubleValue(for: HKUnit.kilocalorie())
                            print("Calories Burned: \(caloriesInKilocalories) kcal")
                            self.calories = caloriesInKilocalories
                        }
                        
                    }
                }
            }
        }
        #endif
    }
}
#endif
