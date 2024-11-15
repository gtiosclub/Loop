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
        NavigationView {
            VStack{
                if viewModel.workoutInProgress {
                    Text("Workout in Progress")
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(8)
                        .padding(.top)
                }
                VStack(spacing: 20) {
                    Text("Select Activity")
                        .font(.title)
                        .padding(.top)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Most Recent")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(activityData, id: \.self) { activity in
                                    NavigationLink(destination: ActivityDetailView(activity: activity)) {
                                        VStack {
                                            Image(systemName: activity.iconName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(.black)
                                            
                                            Text(activity.label)
                                        }
                                        .frame(width: 80, height: 100)
                                        .padding()
                                        .background(Color.gray.opacity(0.2))
                                        .cornerRadius(8)
                                        .foregroundColor(.black)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                    
                    Text("Activities")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    List(activityData, id: \.self) { activity in
                        HStack {
                            Image(systemName: activity.iconName)
                            Text(activity.label)
                        }
                    }
                    .listStyle(PlainListStyle())
                    
                    Spacer()
                }
                .padding()
            }
        }
    }
}
    

struct ActivityDetailView: View {
    let activity: Activity
    
    @State private var timeElapsed: TimeInterval = 0.0
    @State private var timerRunning = false
    @State private var workoutStarted = false

    
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
                    
                    Text(timeString(from: timeElapsed))
                        .font(.system(size: 60, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                    
                    Text("Moving Time")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    Text("00.00")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("Miles")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    HStack {
                        VStack {
                            Text("27:31")
                                .font(.headline)
                                .foregroundColor(.white)
                            Text("AVG PACE")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        VStack {
                            Text("197 BPM")
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
            
            Spacer()
            
            if !workoutStarted {
                      Button(action: {
                          workoutStarted = true
                          timerRunning = true
                      }) {
                          Image(systemName: "play.fill")
                              .font(.largeTitle)
                              .padding(20)
                              .background(Color.gray)
                              .clipShape(Circle())
                              .foregroundColor(Color.white)
                      }
                  } else {
                      HStack(spacing: 50) {
                          Button(action: {
                              timerRunning.toggle()
                          }) {
                              Image(systemName: timerRunning ? "pause.fill" : "play.fill")
                                  .font(.largeTitle)
                                  .padding(20)
                                  .background(Color.gray)
                                  .clipShape(Circle())
                                  .foregroundColor(Color.white)

                          }
                          
                          Button(action: {
                              workoutStarted = false
                              timerRunning = false
                              timeElapsed = 0.0
                          }) {
                              Image(systemName: "stop.fill")
                                  .font(.largeTitle)
                                  .padding(20)
                                  .background(Color.gray)
                                  .clipShape(Circle())
                                  .foregroundColor(Color.white)

                          }
                      }
                  }
              }
              .padding()
              .onAppear(perform: startTimer)
          }
    
    private func startTimer() {
           Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
               if timerRunning {
                   timeElapsed += 1.0
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
