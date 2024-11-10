//
//  excercises.swift
//  LoopWatchAssignment Watch App
//
//  Created by Nitya Potti on 10/7/24.
//

import Foundation
import SwiftUI

@Observable
class ExercisesList: ObservableObject {
    var lists: [excercise]
    init() {
        lists = []
        lists.append(excercise(workoutType: .running, type: "Running", image: "figure.run"))
        lists.append(excercise(workoutType: .cycling, type: "Biking", image: "figure.outdoor.cycle"))
        lists.append(excercise(workoutType: .swimming, type: "Swimming", image: "figure.open.water.swim"))
        lists.append(excercise(workoutType: .hiking, type: "Hiking", image: "figure.hiking"))
        
    }
}
