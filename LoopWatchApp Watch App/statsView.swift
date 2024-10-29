//
//  statsView.swift
//  LoopWatchAssignment Watch App
//
//  Created by Nitya Potti on 10/8/24.
//

import Foundation
import SwiftUI

struct statsView: View {
    @State var timeCount: TimeInterval
    @State var isTimerRunning = false
    @State var timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State var totalCal = 0
    @State var actCal = 0
    @State var avgHundYd = 0
    @State var yard = 0
    @State private var navigateToStatsView = false
    var body: some View {
        NavigationView {
            
            
            VStack {
                
                Text(formatTime(time: timeCount))
                    .bold()
                    .font(.system(size: 40))
                    .foregroundColor(.yellow)
                    .onReceive(timer) { _ in
                        if isTimerRunning {
                            timeCount += 1.0 // Increment time by 1 second
                        }
                    }
                VStack {
                    HStack {
                        Text(String(actCal))
                        Text("Active")
                    }
                    Text("Cal")
                }
                
                VStack {
                    HStack {
                        Text(String(totalCal))
                        Text("Total")
                    }
                    Text("Cal")
                }
                
                VStack {
                    HStack {
                        Text(String(avgHundYd))
                        Text("Average")
                    }
                    Text("/100YD")
                }
                
                Text(String(yard) + "YD")
                
                
                
                
            }
            .gesture(
                DragGesture(minimumDistance: 50)
                    .onEnded { value in
                        print(value)
                        if value.translation.width > 0 { // Swipe right
                            navigateToStatsView = true
                            
                        }
                    })
            NavigationLink(destination: statsViewSecondPage(isTimerRunning: $isTimerRunning), isActive: $navigateToStatsView) {
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

