//
//  FeedView.swift
//  Loop
//
//  Created by Victor Andrade on 10/1/24.
//

import SwiftUI
import FirebaseFirestore

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    let userId: String

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.friendPosts, id: \.id) { post in
                        WorkoutCardView(
                            post: post
                        )
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }
            }
            .navigationTitle("Activity Feed")
            .onAppear {
                viewModel.fetchFriendPosts(for: userId)
            }
        }
    }
}

struct WorkoutCardView: View {
    var post: WorkoutPost

    var body: some View {
        NavigationLink(destination: DetailedStatsView(workoutPost: post)) {
            VStack(spacing: 0) {
                ZStack(alignment: .bottomLeading) {
                    Image("runner_stock")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 160)
                        .clipped()
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, .black.opacity(0.3)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    Text(post.workoutType)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(20)
                        .padding(16)
                }

                VStack(alignment: .leading, spacing: 16) {
                    Text("\(post.name)'s \(post.workoutType) Session")
                        .font(.title3)
                        .fontWeight(.bold)

                    HStack(spacing: 24) {
                        StatItem(title: "Distance", value: "\(post.distance) mi")
                        StatItem(title: "Avg HR", value: post.averageHeartRate)
                        StatItem(title: "Time", value: post.duration)
                        StatItem(title: "Calories", value: "\(post.calories) kcal")
                    }

                    Text(post.date)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(16)
                .background(Color(.systemBackground))
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 5)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatItem: View {
    var title: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.system(size: 16, weight: .semibold))
        }
    }
}

