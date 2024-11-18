//
//  RecordView.swift
//  Loop
//
//  Created by Ryan O’Meara on 10/22/24.
//

import SwiftUI
import WatchConnectivity

struct RecordView: View {
    @StateObject private var viewModel: RecordViewModel
    let userId: String

    init(userId: String) {
       self.userId = userId
       _viewModel = StateObject(wrappedValue: RecordViewModel(userId: userId))
   }
    
    var body: some View {
        
        if viewModel.workoutInProgress {
            
            if (viewModel.workoutType == "Running") {
                let currentActivity = Activity(iconName: "figure.run", label: "Running")
                ActivityDetailView(activity: currentActivity, viewModel: viewModel)
            } else if (viewModel.workoutType == "Biking") {
                let currentActivity = Activity(iconName: "bicycle", label: "Biking")
                ActivityDetailView(activity: currentActivity, viewModel: viewModel)
            } else if (viewModel.workoutType == "Hiking") {
                let currentActivity = Activity(iconName: "figure.walk", label: "Hiking")
                ActivityDetailView(activity: currentActivity, viewModel: viewModel)
            } else {
                ZStack {
                    Color.black
                    
                    Image("Pair Watch")
                        .resizable()
                        .scaledToFit()
                }
            }
        } else {
            ZStack {
                Color.black
                
                Image("Pair Watch")
                    .resizable()
                    .scaledToFit()
            }
        }
    }
}
         
    

struct ActivityDetailView: View {
    let activity: Activity
    @ObservedObject var viewModel: RecordViewModel
    
    
    var body: some View {
        ZStack {
            Color.black
            
            VStack(spacing: 20){
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray)
                        .frame(width: 150, height: 50)
                    
                    HStack {
                        Image(systemName: activity.iconName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        
                        Text((activity.label))
                            .font(.headline)
                    }
                }
                .padding(.bottom, 50)
                                
                VStack {
                    Text(timeString(from: viewModel.totalTime))
                        .font(.system(size: 50, weight: .bold, design: .monospaced))
                        .foregroundColor(.yellow)
                    Text("TIME ELAPSED")
                        .foregroundColor(.yellow)
                }
                .padding()
                
                VStack {
                    Text(String(format: "%.2f", viewModel.currentDistance))
                        .font(.system(size: 100, weight: .bold))
                        .foregroundColor(.white)
                    Text("DISTANCE (mi)")
                        .foregroundColor(.white)
                }
                .padding()
                
                HStack {
                    VStack {
                        Text(String(format: "%.2f", viewModel.currentPace))
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.blue)
                        Text("PACE (mi)")
                            .font(.caption)
                            .foregroundColor(.blue)
                    }
                    Spacer()
                    VStack {
                        Text(String(format: "%.0f", viewModel.currentHeartRate))
                            .font(.system(size: 50, weight: .bold))
                            .foregroundColor(.red)
                        Text("BPM")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
                .padding(.horizontal, 50)
                
                VStack {
                    Text(String(format: "%.0f", viewModel.currentCalories))
                        .font(.system(size: 75, weight: .bold))
                        .foregroundColor(.yellow)
                    Text("CALORIES BURNT")
                        .foregroundColor(.yellow)
                }
                .padding()
            }
        }
    }
       
       // Function to format time
       private func timeString(from time: TimeInterval) -> String {
           let hours = Int(time) / 3600
           let minutes = (Int(time) % 3600) / 60
           let seconds = Int(time) % 60
           return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
       }
   }

struct Activity: Hashable {
    let iconName: String
    let label: String
}

#Preview {
    RecordView(userId: "0F64B991-1B91-4C3B-A899-B6953CC0D934")
        .previewDevice("iPhone 14 Pro")
        .previewDisplayName("Record View Preview")
}
