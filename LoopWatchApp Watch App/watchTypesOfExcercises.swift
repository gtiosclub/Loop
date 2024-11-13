//
//  watchTypesOfExcercise.swift
//  LoopWatchAssignment Watch App
//
//  Created by Nitya Potti on 10/7/24.
//
import SwiftUI

struct WatchTypesOfExerciseView: View {
    @StateObject var exercisesList = ExercisesList()
    @EnvironmentObject var workoutManager: WorkoutManager
    
    @State private var presentedExercise: excercise?
    
    var body: some View {
        
            List(exercisesList.lists) { item in
                Button {
                    presentedExercise = item
                    workoutManager.startWorkout(item.type)
                } label: {
                    VStack {
                        Image(systemName: item.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                        Text(item.type)
                            .font(.headline)
                    }
                }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .cornerRadius(10)
                    
                }
                .buttonStyle(PlainButtonStyle())
                .listStyle(CarouselListStyle())
                .sheet(item: $presentedExercise) { exercise in
                    SessionPagingView(item: exercise)
                        .environmentObject(workoutManager)
                        
                    
            }
    
        
        }
}
