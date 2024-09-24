//
//  HealthKitHelper.swift
//  Loop
//
//  Created by Danny Byrd on 9/24/24.
//

import Foundation
import HealthKit

class HealthKitManager: ObservableObject {
    let healthStore = HKHealthStore()
    @Published var workouts: [HKWorkout] = []
    
    func requestAuthorization() {
        let workoutType = HKObjectType.workoutType()
        let typesToRead: Set = [workoutType]
        
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
            if success {
                self.fetchWorkouts()
            } else if let error = error {
                print("Error requesting HealthKit authorization: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchWorkouts() {
        let workoutType = HKObjectType.workoutType()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: workoutType, predicate: nil, limit: 10, sortDescriptors: [sortDescriptor]) { [weak self] (query, samples, error) in
            if let workouts = samples as? [HKWorkout] {
                DispatchQueue.main.async {
                    self?.workouts = workouts
                }
            }
        }
        healthStore.execute(query)
    }
}

