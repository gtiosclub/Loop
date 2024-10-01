//
//  Activity.swift
//  Loop
//
//  Created by Danny Byrd on 10/1/24.
//

import Foundation
import HealthKit

class Activity {
    var id: String
    var name: String
    var heartRate: HKQuantityTypeIdentifier
    var caloriesBurned: HKQuantityTypeIdentifier
    var distanceWalkingRunning: HKQuantityTypeIdentifier
    var appleExerciseTime: HKQuantityTypeIdentifier
    var vo2Max: HKQuantityTypeIdentifier
    var dateCreated: Date
    
    init(id: String, name: String, heartRate: HKQuantityTypeIdentifier, caloriesBurned: HKQuantityTypeIdentifier, distanceWalkingRunning: HKQuantityTypeIdentifier, appleExerciseTime: HKQuantityTypeIdentifier, vo2Max: HKQuantityTypeIdentifier, dateCreated: Date) {
        self.id = id
        self.name = name
        self.heartRate = heartRate
        self.caloriesBurned = caloriesBurned
        self.distanceWalkingRunning = distanceWalkingRunning
        self.appleExerciseTime = appleExerciseTime
        self.vo2Max = vo2Max
        self.dateCreated = dateCreated
    }
}


