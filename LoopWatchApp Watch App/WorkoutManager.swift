//
//  WorkoutManager.swift
//  Loop
//
//  Created by Joseph Masson on 10/23/24.
//

import HealthKit
import SwiftUI
import os

class WorkoutManager: NSObject, ObservableObject {
    @Published var isRunning = false
    @Published var isPaused = false
    @Published var distance = 0.0  // Distance in miles
    @Published var calories = 0.0  // Calories in kcal
    
    static let shared = WorkoutManager()
    private let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?
    
    func getQuantityType(for workoutType: String) -> [Any] {
        switch workoutType.lowercased() {
        case "running":
            return [
                HKWorkoutActivityType.running,
                HKWorkoutSessionLocationType.outdoor,
                HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) as Any]
        case "biking":
            return [
                HKWorkoutActivityType.cycling,
                HKWorkoutSessionLocationType.outdoor,
                HKQuantityType.quantityType(forIdentifier: .distanceCycling) as Any]
        case "swimming":
            return [
                HKWorkoutActivityType.swimming,
                HKWorkoutSwimmingLocationType.pool,
                HKQuantityType.quantityType(forIdentifier: .distanceSwimming) as Any]
        case "hiking":
            return [
                HKWorkoutActivityType.hiking,
                HKWorkoutSessionLocationType.outdoor,
                HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) as Any]
        default:
            return []
        }
    }

    func startWorkout(_ workoutType: String) {
        distance = 0
        calories = 0
        let quantTypes = getQuantityType(for: workoutType)
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = quantTypes[0] as! HKWorkoutActivityType
        if workoutType.lowercased() == "swimming" {
            configuration.swimmingLocationType = quantTypes[1] as! HKWorkoutSwimmingLocationType

            if configuration.swimmingLocationType == .pool {
                let lapLength = HKQuantity(unit: HKUnit.mile(), doubleValue: 0.1)
                configuration.lapLength = lapLength
            }
        } else {
            configuration.locationType = quantTypes[1] as! HKWorkoutSessionLocationType
        }

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
                    print("Successfully started workout")
                }
            })
            
        } catch {
            print("Failed to start workout: \(error.localizedDescription)")
        }
    }

    func pauseWorkout() {
        guard let session = session else { return }
        
        if session.state == .running {
            session.pause()
            DispatchQueue.main.async {
                print("Session paused on Queue")
                self.isPaused = true
                self.isRunning = false
            }
        }
    }
    
    func resumeWorkout() {
        guard let session = session else { return }

        if session.state == .paused {
            session.resume()
            DispatchQueue.main.async {
                print("Session resumed on Queue")
                self.isPaused = false
                self.isRunning = true
            }
        }
    }

    
    func endWorkout(_ workoutType: String) {
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
    }
    
    func saveWorkoutToHealthStore(workout: HKWorkout, _ workoutType: String) {
        // Total distance in miles (example value, replace with actual calculated value)
        let distanceQuantity = HKQuantity(unit: HKUnit.mile(), doubleValue: distance)

        // Total calories burned (example value, replace with actual calculated value)
        let energyQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)

        // Create the distance sample
        let distanceSample = HKQuantitySample(
            type: getQuantityType(for: workoutType)[2] as! HKQuantityType,
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

extension WorkoutManager: HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    //this manager needs a lot of stubs
    
    
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
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
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        print("Workout session failed: \(error.localizedDescription)")
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // handles workout events if needed
    }

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        // Handle collected data if needed
        for type in collectedTypes {
            if let quantityType = type as? HKQuantityType {
                
                // Track distance traveled for running
                if quantityType == HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) ||
                    quantityType == HKObjectType.quantityType(forIdentifier: .distanceCycling) ||
                    quantityType == HKObjectType.quantityType(forIdentifier: .distanceSwimming){
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
    }
}
