


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
    @State private var shouldNavigateBack: Bool = false 

    enum Tab {
        case controls, metrics, nowPlaying
    }

    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $selection) {
                    ControlsView(type: item.type).tag(Tab.controls)
                    StatsView(timeCount: 0, isTimerRunning: true).tag(Tab.metrics)
                    NowPlayingView().tag(Tab.nowPlaying)
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarHidden(selection == .nowPlaying)
                
                
                NavigationLink("", destination: WatchTypesOfExerciseView()
                                   .environmentObject(workoutManager))
                                   .opacity(0)
                                   
                                   .navigationDestination(isPresented: $shouldNavigateBack) {
                                       WatchTypesOfExerciseView()
                                           .environmentObject(workoutManager)
                                   }
            }
            .onChange(of: workoutManager.isRunning) { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    selection = .metrics
                }
            }
            .onChange(of: workoutManager.backToHome) { newValue in
                if newValue {
                    
                    DispatchQueue.main.async {
                        workoutManager.backToHome = false
                        shouldNavigateBack = true
                    }
                }
            }
        }
    }



    private func displayMetricsView() {
        
        
        withAnimation(.easeInOut(duration: 0.3)) {
            selection = .metrics
        }
    }


}
