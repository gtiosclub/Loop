//  File.swift
//  Loop
//
//  Created by Vikram Parasuram  on 10/1/24.
//

import Foundation
import HealthKit
import SwiftUI

class HealthDataVariables {

    // HealthKit store
    let healthStore = HKHealthStore()

    // Heart Rate data type (QuantityType)
    let heartRateType: HKQuantityType

    // Distance Run data type (QuantityType)
    let distanceRunType: HKQuantityType

    // Workout data type (for Activity Time)
    let workoutType: HKWorkoutType

    // Initializer to set up the data types
    init() {
        // Initialize Heart Rate type with HKQuantityType
        guard let heartRate = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            fatalError("Heart Rate type is not available in HealthKit.")
        }
        self.heartRateType = heartRate

        // Initialize Distance Run type with HKQuantityType
        guard let distanceRun = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            fatalError("Distance Run type is not available in HealthKit.")
        }
        self.distanceRunType = distanceRun

        // Initialize Workout type to track Activity Time
        self.workoutType = HKWorkoutType.workoutType()
    }

    // Optional: Setup function to request authorization (this does not retrieve data)
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        // Data types we want to read
        let typesToRead: Set = [heartRateType, distanceRunType, workoutType]

        // Request authorization to read these types
        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { success, error in
            completion(success, error)
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case heartRate
        case caloriesBurned
        case distanceWalkingRunning
        case appleExerciseTime
        case vo2Max
        case dateCreated
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        name = try container.decode(String.self, forKey: .name)
        items = try container.decode([Item].self, forKey: .items)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(items, forKey: .items)
    }

    
}
