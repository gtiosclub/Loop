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
                print("Pausing workout...")
                workoutManager.pauseWorkout()
                // Call pauseWorkout logic here
            } label: {
                Image(systemName: "pause")
            }
            .tint(Color.yellow)
            .font(.title2)
        }
    }
}

