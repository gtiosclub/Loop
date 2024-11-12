


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
                
                

            }
            .onChange(of: workoutManager.isRunning) { _ in
                withAnimation(.easeInOut(duration: 0.3)) {
                    selection = .metrics
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("", action: {}).opacity(0.0).disabled(true)
                }
            })
        }
    }

    private func displayMetricsView() {
        
        
        withAnimation(.easeInOut(duration: 0.3)) {
            selection = .metrics
        }
    }


}
