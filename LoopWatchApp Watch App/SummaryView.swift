//
//  SummaryView.swift
//  LoopWatchApp Watch App
//
//  Created by Nitya Potti on 10/28/24.
//

import SwiftUI
import HealthKit
struct SummaryView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss) var dismiss
    @State private var durationFormatter:
    DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter
    }()
    var body: some View {
        ScrollView(.vertical) {
            VStack (alignment: .leading) {
                SummaryMetricView(
                    title: "Total Time",
                    value: durationFormatter.string(from: $workoutManager.workout.duration ?? 0.0) ?? ""
                ).accentColor(Color.yellow)
                
                SummaryMetricView(
                    title: "Total Distance", value: Measurement(
                        value: 1625,
                        unit: UnitLength.meters
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .road
                        )
                    )
                ).accentColor(Color.green)
                
                SummaryMetricView(
                    title: "Total Energy",
                    value: Measurement (
                        value: 96,
                        unit: UnitEnergy.kilocalories
                    ).formatted(
                        .measurement(
                            width: .abbreviated,
                            usage: .workout,
                            numberFormatStyle: .number.precision(.fractionLength(0))
                            
                        )
                    )
                ).accentColor(Color.pink)
                SummaryMetricView(
                    title: "Avg. Heart Rate",
                    value: 143
                        .formatted(
                            .number.precision(.fractionLength(0))
                        )
                    + " bpm"
                ).accentColor(Color.red)
                
                Text("Activity Rings")
                ActivityRingsView(
                    healthStore: HKHealthStore()
                ).frame(width: 50, height: 50)
                
                
                
                Button("Done") {
                    dismiss()
                }
                .scenePadding()
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SummaryMetricView: View {
    var title: String
    var value: String
    
    var body: some View {
        Text(title)
        Text(value)
            .font(.system(.title2, design: .rounded)
                .lowercaseSmallCaps()
            )
            .foregroundColor(.accentColor)
        
        Divider()
    }
}
