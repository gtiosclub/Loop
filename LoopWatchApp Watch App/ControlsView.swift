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
                    DispatchQueue.main.async {
                            workoutManager.endWorkout()
                        }
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
                    Image(systemName: workoutManager.isRunning ? "pause" : "play")
                }
                tint(Color.yellow)
                .font(.title2)
                Text (workoutManager.isRunning ? "Pause" : "Resume")
            }
            
        }
       
    }
}
