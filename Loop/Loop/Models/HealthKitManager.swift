//
//  HealthKitManager.swift
//  Loop
//
//  Created by Rexxwell Tendean on 10/22/24.
//

import Foundation
import HealthKit
import WidgetKit

class HealthKitManager: ObservableObject {
    static let shared = HealthKitManager()
    
    var healthStore = HKHealthStore()
    
    var stepCountToday: Int = 0
    var thisWeekSteps: [Int : Int] =
    [
        1: 0,
        2: 0,
        3: 0,
        4: 0,
        5: 0,
        6: 0,
        7: 0
    ]
    var caloriesBurnedToday: Int = 0
    
    init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        let toReads = Set([
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
        ])
        guard HKHealthStore.isHealthDataAvailable() else {
            print("Health data is not available.")
            return
        }
        healthStore.requestAuthorization(toShare: nil, read: toReads) {
            success, error in
            if success {
                self.fetchAllDatas()
            } else {
                print("\(String(describing: error))")
            }
        }
    }
    
    func readStepCountToday() {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return
        }
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: stepCountType, quantitySamplePredicate: predicate, options: .cumulativeSum) {
            _, result, error in
            guard let result = result, let sum = result.sumQuantity() else {
                print("failed to read step count: \(error?.localizedDescription ?? "UNKNOWN ERROR")")
                return
            }
            let steps = Int(sum.doubleValue(for: HKUnit.count()))
            self.stepCountToday = steps
        }
        healthStore.execute(query)
    }
    
    func readCalorieCountToday() {
        guard let calorieCountType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return
        }
        let now = Date()
        let startDate = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now, options: .strictStartDate)
        print("Attempting to get calories burned from \(startDate).")
        let query = HKSampleQuery(sampleType: calorieCountType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) {
            _, result, _ in
            guard let results = result as? [HKQuantitySample], let firstResult = results.first else {
                print("No calorie burn samples found.")
                return;
            }
            let totalCalories = results.reduce(0.0) { $0 + $1.quantity.doubleValue(for: HKUnit.kilocalorie()) }
            self.caloriesBurnedToday = Int(totalCalories)
        }
        healthStore.execute(query)
    }
    
    func fetchAllDatas() {
        print("////////////////////////////////////////")
        print("Attempting to fetch all Datas")
        readStepCountToday()
        readCalorieCountToday()
        
        print("DATAS FETCHED: ")
        print("\(stepCountToday) steps today")
        print("\(caloriesBurnedToday) calories burned today")
        print("////////////////////////////////////////")
        
//        WidgetCenter.shared.reloadAllTimelines()
    }
}
