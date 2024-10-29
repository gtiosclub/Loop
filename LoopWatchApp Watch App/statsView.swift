//
//  statsView.swift
//  LoopWatchAssignment Watch App
//
//  Created by Nitya Potti on 10/8/24.
//

import Foundation
import SwiftUI

struct ActivityData {
    let type: String
    var timeCount: TimeInterval
    var isTimerRunning = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
}

struct statsView: View {
    @State var type:String
    @State var timeCount: TimeInterval
    @State var isTimerRunning = false
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var navigateToStatsView = false
    
    @EnvironmentObject var workoutManager: WorkoutManager

    var body: some View {
        VStack {
            Text(formatTime(time: timeCount))
                .bold()
                .font(.system(size: 40))
                .foregroundColor(.yellow)
                .onReceive(timer) { _ in
                    if isTimerRunning {
                        timeCount += 1.0 // Increment time by 1 second
                    }
                }
            Text(type)
                .font(.system(size: 30))
            HStack {
                Text("Distance: \(workoutManager.distance, specifier: "%.2f") meters")
            }
            HStack {
                Text("Calories: \(workoutManager.calories, specifier: "%.2f") kcal")
            }
            
            // Stop Workout Button
            Button(action: {
                isTimerRunning = false
                workoutManager.endWorkout()
            }) {
                Text("End Timer (workout)")
                    .foregroundColor(.red)
            }
        }
    }
    
    func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%.2d:%.2d", minutes, seconds)
        
    }
}

