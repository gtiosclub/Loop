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
            Button {
                print("Ending workout...")
                workoutManager.endWorkout()
            } label: {
                Image(systemName: "xmark")
            }
            .tint(Color.red)
            .font(.title2)
            
            Button {
                print("Pausing/Resuming workout...")
                
                if (workoutManager.isPaused) {
                        workoutManager.resumeWorkout()
                    } else {
                        workoutManager.pauseWorkout()
                    }
                
            } label: {
                Image(systemName: workoutManager.isPaused ? "play" :"pause")
            }
            .tint(Color.yellow)
            .font(.title2)
        }
    }
}

