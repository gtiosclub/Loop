//
//  ControlsView.swift
//  LoopWatchApp Watch App
//
//  Created by Nitya Potti on 10/28/24.
//

import SwiftUI

struct ControlsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss)
    private var dismiss
    @State var type: String

    var body: some View {
        HStack {
            Button {
                dismiss()
                print("Ending workout...")
                workoutManager.endWorkout(type)
            } label: {
                Image(systemName: "xmark")
            }
            .tint(Color.red)
            .font(.title2)
            
            Button {
                print("Pausing/Resuming workout")
                
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

