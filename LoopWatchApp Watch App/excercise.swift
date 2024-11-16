//
//  excercise.swift
//  LoopWatchAssignment Watch App
//
//  Created by Nitya Potti on 10/7/24.
//

import Foundation
import SwiftUI
import HealthKit


@Observable
class excercise: Identifiable {
    var workoutType: HKWorkoutActivityType
    var type: String
    var image: String
    init(workoutType: HKWorkoutActivityType, type: String, image: String) {
        self.workoutType = workoutType
        self.type = type
        self.image = image
    }
}
