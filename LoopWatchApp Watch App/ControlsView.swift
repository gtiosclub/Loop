//
//  ControlsView.swift
//  LoopWatchApp Watch App
//
//  Created by Nitya Potti on 10/28/24.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    var body: some View {
        HStack {
            VStack {
                Button {
                    workoutManager.endWorkout()
                } label: {
                    Image(systemName: "xmark")
                }
                tint(Color.red)
                .font(.title2)
                Text ("End")
            }
            VStack {
                Button {
                    workoutManager.isRunning ? workoutManager.pauseWorkout() : workoutManager.resumeWorkout()
                } label: {
                    Image(systemName: workoutManager.isRunning ? "Pause" : "Resume")
                }
                tint(Color.yellow)
                .font(.title2)
                Text (workoutManager.isRunning ? "Pause" : "Resume")
            }
            
        }
    }
}
