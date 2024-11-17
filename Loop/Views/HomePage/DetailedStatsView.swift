import SwiftUI
import Charts
import CoreLocation
import MapKit

struct DetailedStatsView: View {
    var workoutPost: WorkoutPost
    
    private var routePoints: [CLLocation] {
        workoutPost.routeLocations.map { location in
            CLLocation(latitude: location.latitude, longitude: location.longitude)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Workout Summary")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("by \(workoutPost.name)")
                        .font(.title3)
                        .foregroundColor(.gray)
                    Text("\"Keep pushing forward!\"")
                        .font(.headline)
                        .italic()
                }
                .padding([.horizontal, .top])

                SummaryStatsSection(
                    distance: workoutPost.distance,
                    duration: workoutPost.duration,
                    calories: workoutPost.calories
                )
                
                // Route Map Section
                if !workoutPost.routeLocations.isEmpty {
                    ChartSection(
                        title: "Route Map",
                        chart: AnyView(
                            MapViewUI(routePoints: routePoints)
                                .frame(height: 300)
                        )
                    )
                }

                // Heart Rate Chart Section
                if !workoutPost.heartRatePoints.isEmpty {
                    ChartSection(
                        title: "Heart Rate Over Time",
                        chart: AnyView(
                            Chart {
                                ForEach(workoutPost.heartRatePoints) { entry in
                                    LineMark(
                                        x: .value("Time", entry.date),
                                        y: .value("Heart Rate", entry.value)
                                    )
                                    .foregroundStyle(Color.red)
                                }
                            }
                            .chartXAxis {
                                AxisMarks(values: .automatic(desiredCount: 5)) { value in
                                    AxisValueLabel(format: .dateTime.hour().minute().second())
                                }
                            }
                            .frame(height: 200)
                        )
                    )
                } else {
                    Text("No heart rate data available.")
                        .padding()
                }
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
    var distance: String
    var duration: String
    var calories: String

    var body: some View {
        HStack {
            SummaryStatItem(title: "Distance", value: "\(distance) mi", icon: "map.fill")
            SummaryStatItem(title: "Duration", value: duration, icon: "clock.fill")
            SummaryStatItem(title: "Calories", value: "\(calories) kcal", icon: "flame.fill")
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

struct DetailedStatsView_Previews: PreviewProvider {
    static var previews: some View {
        let samplePost = WorkoutPost(
            id: "sample",
            name: "Sample Name",
            avatar: "person.crop.circle",
            workoutType: "Running",
            distance: "5.0",
            pace: "6:30",
            duration: "30m 0s",
            calories: "300",
            date: "Nov 11, 2024 at 1:53 PM",
            averageHeartRate: "120 bpm",
            heartRatePoints: [],
            routeLocations: [
                RouteLocation(latitude: 42.047285, longitude: -87.680009),
                RouteLocation(latitude: 42.047294, longitude: -87.680312)
            ],
            timestamp: Date()
        )
        DetailedStatsView(workoutPost: samplePost)
    }
}
