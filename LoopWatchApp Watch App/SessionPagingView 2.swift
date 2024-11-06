


//  SessionPagingView.swift
//  Loop
//
//  Created by Nitya Potti on 10/27/24.


import SwiftUI
import WatchKit
struct SessionPagingView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @State var item: excercise
    @State private var selection: Tab = .metrics
    
    enum Tab {
        case controls, metrics, nowPlaying
    }
    var body: some View {
        TabView(selection: $selection) {
            ControlsView().tag(Tab.controls)
            //statsView(type:item.type, timeCount: 0, isTimerRunning: true).tag(Tab.metrics)
            StatsView().tag(Tab.metrics)
            NowPlayingView().tag(Tab.nowPlaying)
        }
        //.navigationTitle(item.type)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(selection == .nowPlaying)
        .onChange(of: workoutManager.isRunning) { oldValue, newValue in
            print("isRunning changed to \(newValue)")
            withAnimation(.easeInOut(duration: 0.3)) {
                displayMetricsView()
            }
            
        }
        .onChange(of: workoutManager.backToHome) { oldValue, newValue in
                        if newValue {
                            WatchTypesOfExerciseView()
                            workoutManager.backToHome = false // Reset the flag
                        }
        }
        


    }
        

    private func displayMetricsView() {
        
        
        withAnimation(.easeInOut(duration: 0.3)) {
            selection = .metrics
        }
    }


}
