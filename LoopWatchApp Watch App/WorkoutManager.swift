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
    @Published var distance = 0.0  // Distance in meters
    @Published var calories = 0.0  // Calories in kcal
    
    static let shared = WorkoutManager()
    private let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    private var builder: HKLiveWorkoutBuilder?

    func startWorkout() {
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

    
    func endWorkout() {
        guard let session = session, let builder = builder else { return }

        // First, end the session
        session.end()

        // Then, end the data collection
        builder.endCollection(withEnd: Date()) { success, error in
            if success {
                // Finalize the workout
                self.builder?.finishWorkout(completion: { (finalWorkout, error) in
                    if let error = error {
                        print("Error finishing workout: \(error.localizedDescription)")
                    } else {
                        print("Workout successfully finished!")
                    }
                })
            } else if let error = error {
                print("Error ending workout collection: \(error.localizedDescription)")
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
    }
}
/*
//
//  HealthManager.swift
//  LoopWatchApp Watch App
//
//  Created by Amiire kolawole on 2024-10-23.
//

import Foundation
import HealthKit

extension Date {
    static var startOfDay: Date {
        Calendar.current.startOfDay(for: Date())
    }
}

class HealthManager: ObservableObject {
    
    let healthStore = HKHealthStore()
    init() {
        let steps = HKQuantityType(.stepCount)
        let distance = HKQuantityType(.distanceWalkingRunning)
        let calories = HKQuantityType(.activeEnergyBurned)

        
        let healthTypes: Set = [steps, distance, calories]
        
        Task {
            do {
                try await healthStore.requestAuthorization(toShare: [], read: healthTypes)
            } catch{
                    print("Error fetching data")
            }
            
        }
    }
    
    func fetchTodayCalories() {
        let caloriesToday = HKQuantityType(.activeEnergyBurned)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: caloriesToday, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching calories data")
                return
            }
            
            let caloriesBurned = quantity.doubleValue(for: .count())
            print(caloriesBurned)
        }
    }
    
    func fetchTodaySteps() -> Int {
        let stepsToday = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: stepsToday, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching steps data")
                return
            }
            
            let stepsTotal = quantity.doubleValue(for: .count())
            print(stepsTotal)
            return
        }
        
        return 0
    }
    func fetchTodayDistance() {
        let distanceToday = HKQuantityType(.distanceWalkingRunning)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        let query = HKStatisticsQuery(quantityType: distanceToday, quantitySamplePredicate: predicate) { _, result, error in
            guard let quantity = result?.sumQuantity(), error == nil else {
                print("Error fetching distance data")
                return
            }
            
            let distanceTotal = quantity.doubleValue(for: .count())
            print(distanceTotal)
        }
    }
}
*/
