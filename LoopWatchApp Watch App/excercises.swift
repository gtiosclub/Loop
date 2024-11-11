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
        lists.append(excercise(type: "Running", image: "figure.run"))
        lists.append(excercise(type: "Biking", image: "figure.outdoor.cycle"))
        lists.append(excercise(type: "Swimming", image: "figure.open.water.swim"))
        lists.append(excercise(type: "Hiking", image: "figure.hiking"))
        
    }
}
