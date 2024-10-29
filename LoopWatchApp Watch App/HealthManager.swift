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
