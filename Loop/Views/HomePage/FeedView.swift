//
//  FeedView.swift
//  Loop
//
//  Created by Victor  Andrade on 10/1/24.
//

import SwiftUI

struct FeedView: View {
    @ObservedObject var viewModel = FeedViewModel()
        
        var body: some View {
            //TODO::
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Speedy boy Summer")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.pink)
                        Text("Most Miles ran")
                            .font(.title3)
                            .foregroundColor(.gray)
                        Text("6/1 - 9/1")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Leaderboard")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.orange)
                        
                        LeaderboardEntry(rank: 1, name: "Rocky", miles: 135.6, color: .yellow)
                        LeaderboardEntry(rank: 2, name: "You", miles: 104.8, color: .gray)
                        LeaderboardEntry(rank: 2, name: "David Goggins", miles: 85, color: .orange)
                        
                       
                        
                    }
                    .padding(.horizontal)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Activities")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.blue)
                        ActivityEntry (
                            name: "Rocky ",
                            description: "Morning Run",
                            quote: "stay on top",
                            distance: 7.4,
                            pace: "8:16/mi",
                            calories: 756,
                            heartRate: 167,
                            duration: "1:01:10",
                            mapLocation: "Philadelphia"
                        )
                        ActivityEntry (
                            name: "Arnold ",
                            description: "Morning Lift",
                            quote: "stay on top",
                            distance: 7.4,
                            pace: "8:16/mi",
                            calories: 756,
                            heartRate: 167,
                            duration: "1:01:10",
                            mapLocation: "Austria"
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        
        }
}
struct LeaderboardEntry: View {
    let rank: Int
    let name: String
    let miles: Double
    let color: Color

    var body: some View {
        HStack {
            Text("\(rank)")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text(name)
                .font(.headline)
                .foregroundColor(.primary)
            
            Spacer()
            
            Text("\(miles, specifier: "%.1f") mi")
                .font(.headline)
                .foregroundColor(.primary)
            
            Rectangle()
                .fill(color)
                .frame(width: CGFloat(miles), height: 10)
        }
    }
}
struct ActivityEntry: View {
    let name: String
    let description: String
    let quote: String
    let distance: Double
    let pace: String
    let calories: Int
    let heartRate: Int
    let duration: String
    let mapLocation: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(name) - \(description)")
                .font(.headline)
            
            Text("\"\(quote)\"")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack(spacing: 16) {
                StatView(icon: "figure.run", value: String(format: "%.1f", distance) + " mi")
                StatView(icon: "clock", value: pace)
                StatView(icon: "flame", value: "\(calories) cals")
                StatView(icon: "heart", value: "\(heartRate) bpm")
                StatView(icon: "timer", value: duration)
            }
            
            // Placeholder for map view
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.5))
                .frame(height: 200)
                .overlay(Text(mapLocation))
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
struct StatView: View {
    let icon: String
    let value: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.subheadline)
        }
    }
}


#Preview {
    FeedView()
}

