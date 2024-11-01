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
    
    var body: some View {
        NavigationStack {
            List(exercisesList.lists) { item in
                NavigationLink(destination:SessionPagingView2(item: item)
                            .environmentObject(workoutManager)
                            .onAppear {
                                workoutManager.startWorkout(item.type)
                            }) {
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
            }
            .listStyle(CarouselListStyle())
        }
    }
}
