//
//  Activity.swift
//  Loop
//
//  Created by Danny Byrd on 10/1/24.
//

import Foundation
import HealthKit
import SwiftUI


class Activity: Identifiable, Codable {
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


