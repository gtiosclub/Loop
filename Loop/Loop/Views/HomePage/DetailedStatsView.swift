//
//  DetailedStatsView.swift
//  Loop
//
//  Created by Jason Nair on 10/8/24.
//

import SwiftUI
import Charts

struct DetailedStatsView: View {
    var name: String

    let paceData: [PaceEntry] = [
        PaceEntry(time: 0, pace: 8.5),
        PaceEntry(time: 1, pace: 8.2),
        PaceEntry(time: 2, pace: 8.0),
        PaceEntry(time: 3, pace: 7.8),
        PaceEntry(time: 4, pace: 8.1),
        PaceEntry(time: 5, pace: 7.9),
        PaceEntry(time: 6, pace: 8.3),
        PaceEntry(time: 7, pace: 8.0)
    ]

    let elevationData: [ElevationEntry] = [
        ElevationEntry(distance: 0, elevation: 100),
        ElevationEntry(distance: 1, elevation: 110),
        ElevationEntry(distance: 2, elevation: 105),
        ElevationEntry(distance: 3, elevation: 115),
        ElevationEntry(distance: 4, elevation: 120),
        ElevationEntry(distance: 5, elevation: 118),
        ElevationEntry(distance: 6, elevation: 122),
        ElevationEntry(distance: 7, elevation: 125)
    ]

    let heartRateData: [HeartRateEntry] = [
        HeartRateEntry(time: 0, bpm: 150),
        HeartRateEntry(time: 1, bpm: 155),
        HeartRateEntry(time: 2, bpm: 160),
        HeartRateEntry(time: 3, bpm: 165),
        HeartRateEntry(time: 4, bpm: 170),
        HeartRateEntry(time: 5, bpm: 168),
        HeartRateEntry(time: 6, bpm: 166),
        HeartRateEntry(time: 7, bpm: 162)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {

                VStack(alignment: .leading, spacing: 8) {
                    Text("Workout Summary")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("by \(name)")
                        .font(.title3)
                        .foregroundColor(.gray)
                    Text("\"Keep pushing forward!\"")
                        .font(.headline)
                        .italic()
                }
                .padding([.horizontal, .top])

    
                SummaryStatsSection()

  
                ChartSection(
                    title: "Pace Over Time",
                    chart: AnyView(
                        Chart {
                            ForEach(paceData) { entry in
                                LineMark(
                                    x: .value("Time (mi)", entry.time),
                                    y: .value("Pace (min/mi)", entry.pace)
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(Color.blue)
                                .lineStyle(StrokeStyle(lineWidth: 3))
                                .symbol(Circle().strokeBorder(lineWidth: 2))
                            }
                        }
                        .chartXScale(domain: [0, 7])
                        .chartYScale(domain: [7.5, 9])
                    )
                )

          
                ChartSection(
                    title: "Elevation Gain",
                    chart: AnyView(
                        Chart {
                            ForEach(elevationData) { entry in
                                BarMark(
                                    x: .value("Distance (mi)", entry.distance),
                                    y: .value("Elevation (ft)", entry.elevation)
                                )
                                .foregroundStyle(Color.green)
                            }
                        }
                        .chartXScale(domain: [0, 7])
                        .chartYScale(domain: [0, 130])
                    )
                )

                ChartSection(
                    title: "Heart Rate Zones",
                    chart: AnyView(
                        Chart {
                            ForEach(heartRateData) { entry in
                                AreaMark(
                                    x: .value("Time (mi)", entry.time),
                                    y: .value("Heart Rate (bpm)", entry.bpm)
                                )
                                .foregroundStyle(
                                    .linearGradient(
                                        colors: [.red.opacity(0.6), .red.opacity(0.2)],
                                        startPoint: .init(x: 0.5, y: 0),
                                        endPoint: .init(x: 0.5, y: 1)
                                    )
                                )
                            }
                        }
                        .chartXScale(domain: [0, 7])
                        .chartYScale(domain: [0, 180])
                        .frame(maxWidth: .infinity)
                    )
                )

            }
            .padding(.vertical)
        }
        .background(Color(.systemGray6))
        .navigationTitle("Workout Stats")
        .navigationBarHidden(false)
    }
}


struct ChartSection: View {
    var title: String
    var chart: AnyView

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            chart
                .frame(height: 200)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 5)
        )
        .padding([.horizontal, .top])
    }
}

struct SummaryStatsSection: View {
    var body: some View {
        HStack {
            SummaryStatItem(title: "Distance", value: "7.4 mi", icon: "map.fill")
            SummaryStatItem(title: "Duration", value: "1h 1m", icon: "clock.fill")
            SummaryStatItem(title: "Calories", value: "756 kcal", icon: "flame.fill")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(radius: 5)
        )
        .padding([.horizontal, .top])
    }
}

struct SummaryStatItem: View {
    var title: String
    var value: String
    var icon: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}


struct PaceEntry: Identifiable {
    let id = UUID()
    let time: Double
    let pace: Double
}

struct HeartRateEntry: Identifiable {
    let id = UUID()
    let time: Double
    let bpm: Int
}

struct ElevationEntry: Identifiable {
    let id = UUID()
    let distance: Double
    let elevation: Double
}

struct DetailedStatsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedStatsView(name: "Sample Name")
    }
}

