//
//  watchTypesOfExcercise.swift
//  LoopWatchAssignment Watch App
//
//  Created by Nitya Potti on 10/7/24.
//
import SwiftUI

struct WatchTypesOfExerciseView: View {
    @EnvironmentObject var manager:HealthManager
    @StateObject var exercisesList = ExercisesList()
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        NavigationStack {
            List(exercisesList.lists) { item in
                NavigationLink(destination: statsView(activity: ActivityData(type: item.type, timeCount: 0, isTimerRunning: true)).environmentObject(manager)) {
                    VStack {
                        Image(systemName: item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        Text(item.type)
                            .font(.headline)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .cornerRadius(10)
                }
                .buttonStyle(PlainButtonStyle())
                .onTapGesture {
                    workoutManager.startWorkout()
                }
            }
            .listStyle(CarouselListStyle())
        }
    }
}