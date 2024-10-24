//
//  statsView.swift
//  LoopWatchAssignment Watch App
//
//  Created by Nitya Potti on 10/8/24.
//

import Foundation
import SwiftUI

struct ActivityData {
    let type: String
    var timeCount: TimeInterval
    var isTimerRunning = false
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    var totalCal = 0
    var actCal = 0
    var avgHundYd = 0
    var yard = 0
}

struct statsView: View {
    @State var activity: ActivityData
    @State private var navigateToStatsView = false
    @EnvironmentObject var manager:HealthManager
    
    var body: some View {
        NavigationView {
            
            
            VStack {
                
                Text(formatTime(time: activity.timeCount))
                    .bold()
                    .font(.system(size: 40))
                    .foregroundColor(.yellow)
                    .onReceive(activity.timer) { _ in
                        if activity.isTimerRunning {
                            activity.yard += manager.fetchTodaySteps()
                            activity.timeCount += 1.0 // Increment time by 1 second
                        }
                    }
                VStack {
                    HStack {
                        Text(String(activity.actCal))
                        Text("Active")
                    }
                    Text("Cal")
                }
                
                VStack {
                    HStack {
                        Text(String(activity.totalCal))
                        Text("Total")
                    }
                    Text("Cal")
                }
                
                VStack {
                    HStack {
                        Text(String(activity.avgHundYd))
                        Text("Average")
                    }
                    Text("/100YD")
                }
                
                Text(String(activity.yard) + "YD")
                
                
                
                
            }
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { value in
                        print(value)
                        if value.translation.width > 0 { // Swipe right
                            navigateToStatsView = true
                            
                        }
                    })
            NavigationLink(destination: statsViewSecondPage(isTimerRunning: $activity.isTimerRunning), isActive: $navigateToStatsView) {
                EmptyView()
            }
        }
            
    }
    func formatTime(time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%.2d:%.2d", minutes, seconds)
        
    }
}

