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


enum WorkoutType {
    case running(HKWorkoutActivityType, HKQuantityType, HKWorkoutSessionLocationType)
    case biking(HKWorkoutActivityType, HKQuantityType, HKWorkoutSessionLocationType)
    case swimming(HKWorkoutActivityType, HKQuantityType, HKWorkoutSwimmingLocationType)
    case hiking(HKWorkoutActivityType, HKQuantityType, HKWorkoutSessionLocationType)

    init(_ type: String) {
        switch type {
        case "running":
            self = .running(HKWorkoutActivityType.running,
                            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                            HKWorkoutSessionLocationType.outdoor)
        case "biking":
            self = .biking(HKWorkoutActivityType.cycling,
                           HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
                           HKWorkoutSessionLocationType.outdoor)
        case "swimming":
            self = .swimming(HKWorkoutActivityType.swimming,
                             HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!,
                             HKWorkoutSwimmingLocationType.pool)
        case "hiking":
            self = .hiking(HKWorkoutActivityType.hiking,
                           HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                           HKWorkoutSessionLocationType.outdoor)
        default:
            fatalError("Unsupported workout type")
        }
    }
    
    func getType() -> HKWorkoutActivityType {
        switch self {
        case .running(let type, _, _),
            .biking(let type, _, _),
            .swimming(let type, _, _),
            .hiking(let type, _, _):
            return type
        }
    }
    
    func getQuantityType() -> HKQuantityType{
        switch self {
        case .running(_, let quantityType, _),
            .biking(_, let quantityType, _),
            .swimming(_, let quantityType, _),
            .hiking(_, let quantityType, _):
            return quantityType
        }
    }
    
    func getLocation() -> Any {
        switch self {
        case .running(_, _, let location),
            .biking(_, _, let location),
            .hiking(_, _, let location):
            return location as Any
        case .swimming(_, _, let location):
            return location as Any
        }
    }
    
    func configure() -> HKWorkoutConfiguration {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = getType()
        switch self {
        case .running,
            .biking,
            .hiking:
            configuration.locationType = getLocation() as! HKWorkoutSessionLocationType
        case .swimming:
            configuration.swimmingLocationType = getLocation() as! HKWorkoutSwimmingLocationType
            configuration.lapLength = HKQuantity(unit: HKUnit.mile(), doubleValue: 0.1)
        }
        return configuration
    }
    
}


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
    @Published var distance = 0.0  // Distance in miles
    @Published var calories = 0.0  // Calories in kcal
    @Published var isWorkoutInProgress = false
    
    static let shared = WorkoutManager()
    private let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    @Published var backToHome: Bool = false
    @Published var showingSummaryView: Bool = false {
        didSet {
            if showingSummaryView == false {
                resetWorkout()
                
            }

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

    func startWorkout(_ workoutType: String) {
        #if os(watchOS)
        distance = 0
        calories = 0
        let configuration:HKWorkoutConfiguration = WorkoutType(workoutType.lowercased()).configure()

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

    func resetWorkout() {
        builder = nil
        session = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
        backToHome = true
    }
    
    func endWorkout(_ workoutType: String) {
        #if os(watchOS)
        guard let session = session, let builder = builder else { return }

        // First, end the session
        session.end()

        // Then, end the data collection
        builder.endCollection(withEnd: Date()) { success, error in
            if success {
                // Finalize the workout
                self.builder?.finishWorkout(completion: { (workout, error) in
                    if let error = error {
                        print("Error finishing workout: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            self.isWorkoutInProgress = false
                        }
                        print("Workout successfully finished!")
                    }
                    
                    guard let workout = workout else {
                        print("No workout generated")
                        return
                    }
                    
                    self.saveWorkoutToHealthStore(workout: workout, workoutType)
                })
            } else if let error = error {
                print("Error ending workout collection: \(error.localizedDescription)")
            }
        }
      
        showingSummaryView = true
        print("showingSummaryView set to \(showingSummaryView)")
      
        // Update iPhone app
        self.sendWorkoutEndedMessage()

        #endif
    }
          
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance2: Double = 0
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }
    
    func saveWorkoutToHealthStore(workout: HKWorkout, _ workoutType: String) {
        // Total distance in miles (example value, replace with actual calculated value)
        let distanceQuantity = HKQuantity(unit: HKUnit.mile(), doubleValue: distance)

        // Total calories burned (example value, replace with actual calculated value)
        let energyQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)

        // Create the distance sample
        let distanceSample = HKQuantitySample(
            type: WorkoutType(workoutType.lowercased()).getQuantityType(),
            quantity: distanceQuantity,
            start: workout.startDate,
            end: workout.endDate
        )
        
        // Create the energy sample
        let energySample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            quantity: energyQuantity,
            start: workout.startDate,
            end: workout.endDate
        )

        // Save the workout and associated samples to HealthKit
        healthStore.save([workout, distanceSample, energySample]) { (success, error) in
            if let error = error {
                print("Error saving workout to HealthKit: \(error.localizedDescription)")
            } else {
                print("Workout successfully saved to HealthKit")
            }
        }
    }
}

#if os(watchOS)
extension WorkoutManager: HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
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
                
                // Track distance traveled for running
                if quantityType == HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) ||
                    quantityType == HKObjectType.quantityType(forIdentifier: .distanceCycling) ||
                    quantityType == HKObjectType.quantityType(forIdentifier: .distanceSwimming) {
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
