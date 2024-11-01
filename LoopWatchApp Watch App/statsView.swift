//
//  statsView.swift
//  LoopWatchAssignment Watch App
//
//  Created by Nitya Potti on 10/8/24.
//

import Foundation
import SwiftUI

struct statsView: View {
    @State var type:String
    @State var timeCount: TimeInterval
    @State var isTimerRunning = false
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var navigateToStatsView = false
    @EnvironmentObject var workoutManager: WorkoutManager

    var body: some View {
        VStack {
            HStack {
                Text(formatTime(time: timeCount))
                    .bold()
                    .font(.system(size: 40))
                    .foregroundColor(.yellow)
                    .onReceive(timer) { _ in
                        if isTimerRunning {
                            timeCount += 1.0 // Increment time by 1 second
                        }
                    }.frame(width:160)
//                Button(action: {
//                    if (workoutManager.isRunning || workoutManager.isPaused) {
//                        isTimerRunning.toggle()
//                        if (isTimerRunning) {
//                            workoutManager.resumeWorkout()
//                        } else {
//                            workoutManager.pauseWorkout()
//                        }
//                    }
//                }) {
//                    Image(systemName: isTimerRunning ? "pause.circle" : "play.circle.fill")
//                }
//                .buttonStyle(PlainButtonStyle())
            }
            Text(type)
                .font(.system(size: 30))
            HStack {
                Text("Distance: \(workoutManager.distance, specifier: "%.3f") mi")            }
            HStack {
                Text("Calories: \(workoutManager.calories, specifier: "%.2f") kcal")
            }
            
            
            // Stop Workout Button
//            Button(action: {
//                if (workoutManager.isRunning || workoutManager.isPaused) {
//                    isTimerRunning = false
//                    workoutManager.resumeWorkout()
//                    workoutManager.endWorkout()
//                }
//            }) {
//                var open = workoutManager.isRunning || workoutManager.isPaused
//                Text(open ? "End Workout" : "Workout Ended")
//                    .foregroundColor(open ? .red : .white)
//            }
            
            
        }
        .onChange(of: workoutManager.isPaused) { oldValue, isPaused in
                    isTimerRunning = !isPaused // Stop the timer when paused
                }
//        .gesture(
//            DragGesture(minimumDistance: 50)
//                .onEnded { value in
//                    print(value)
//                    if value.translation.width > 0 { // Swipe right
//                        navigateToStatsView = true
//                        
//                    }
//                })
//        NavigationLink(destination: statsViewSecondPage(isTimerRunning: $isTimerRunning), isActive: $navigateToStatsView) {
//            EmptyView()
//        }
    }
    
    func formatTime(time: TimeInterval) -> String {
        if (time > 3600) {
            let hours = Int(time) / 3600
            let minutes = (Int(time) % 3600) / 60
            let seconds = Int(time) % 60
            return String(format: "%.2d:%.2d:%.2d", hours, minutes, seconds)
        }
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%.2d:%.2d", minutes, seconds)
        
    }
}

