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
            } else if  (viewModel.workoutType == "Hiking") {
                let currentActivity = Activity(iconName: "figure.walk", label: "Hiking")
                ActivityDetailView(activity: currentActivity, viewModel: viewModel)
            }
            
        } else {
            Text("Start a workout on your Apple Watch")
        }
    }
}
         
    

struct ActivityDetailView: View {
    let activity: Activity
    @ObservedObject var viewModel: RecordViewModel
    
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.gray)
                    .frame(height: 500)
                
                VStack(spacing: 20) {
                    Image(systemName: activity.iconName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 45, height: 45)
                        .foregroundColor(.white)
                    
                    Text((activity.label)) .font(.headline) .padding(.top)
                        .foregroundColor(.white)
                    
                    Text(timeString(from: viewModel.totalTime))
                        .font(.system(size: 60, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Text("Moving Time")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Text(String(format: "%.2f", viewModel.currentDistance))
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Miles")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    HStack {
                        VStack {
                            Text(String(format: "%.2f", viewModel.currentPace))
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("AVG PACE")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack {
                            Text(String(format: "%.0f BPM", viewModel.currentHeartRate))
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("BPM")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal, 40)
                }
                .padding()
            }
        }
        .padding()
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

let activityData = [
    Activity(iconName: "figure.run", label: "Running"),
    Activity(iconName: "bicycle", label: "Biking"),
    Activity(iconName: "figure.walk", label: "Hiking")
]

#Preview {
    RecordView(userId: "0F64B991-1B91-4C3B-A899-B6953CC0D934")
        .previewDevice("iPhone 14 Pro")
        .previewDisplayName("Record View Preview")
}
