//
//  FeedView.swift
//  Loop
//
//  Created by Victor Andrade on 10/1/24.
//
import SwiftUI
import FirebaseFirestore

struct FeedView: View {
    @StateObject private var viewModel: FeedViewModel
    @State private var selectedFilter: WorkoutType = .all
    @State private var showFilterSheet = false
    let userId: String
    
    init(userId: String) {
        self.userId = userId
        _viewModel = StateObject(wrappedValue: FeedViewModel(currentUserId: userId))
    }
    
    enum WorkoutType: String, CaseIterable {
        case all = "All"
        case running = "Running"
        case biking = "Biking"
        case swimming = "Swimming"
    }
    
    var filteredPosts: [WorkoutPost] {
        if selectedFilter == .all {
            return viewModel.friendPosts
        }
        return viewModel.friendPosts.filter { $0.workoutType == selectedFilter.rawValue }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(WorkoutType.allCases, id: \.self) { type in
                                FilterChip(
                                    title: type.rawValue,
                                    isSelected: selectedFilter == type,
                                    action: { selectedFilter = type }
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top)
                    
                    ForEach(filteredPosts) { post in
                        WorkoutCardView(post: post, viewModel: viewModel)
                            .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Activity Feed")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showFilterSheet.toggle() }) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundStyle(.blue)
                    }
                }
            }
            .onAppear {
                viewModel.fetchFriendPosts(for: userId)
            }
        }
    }
}

struct WorkoutCardView: View {
    var post: WorkoutPost
    @ObservedObject var viewModel: FeedViewModel
    @State private var showingComments = false
    @State private var animateHeart = false
    
    private var isLiked: Bool {
        post.likes.contains(viewModel.currentUserId)
    }
    
    private var isOwnPost: Bool {
        post.userId == viewModel.currentUserId
    }
    
    private var workoutColor: Color {
        switch post.workoutType {
        case "Running": return .blue
        case "Biking": return .purple
        case "Swimming": return .orange
        default: return .green
        }
    }
    
    var body: some View {
        NavigationLink(destination: DetailedStatsView(workoutPost: post)) {
            VStack(spacing: 0) {
                if isOwnPost {
                    HStack {
                        Text("Your Workout")
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(4)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                
                HStack {
                    if post.avatar == "person.crop.circle" {
                        Image(systemName: post.avatar)
                            .font(.title2)
                            .foregroundColor(workoutColor)
                            .padding(8)
                            .background(workoutColor.opacity(0.1))
                            .clipShape(Circle())
                    } else {
                        if let url = URL(string: post.avatar) {
                            AsyncImage(url: url) { image in
                                image.resizable().frame(width: 30, height: 30).clipShape(.circle)
                            } placeholder: {
                                Circle()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(workoutColor.opacity(0.1))
                                    .padding()
                                    .overlay {
                                        ProgressView()
                                    }
                            }
                        } else {
                            Image(systemName: "person.crop.circle")
                                .font(.title2)
                                .foregroundColor(workoutColor)
                                .padding(8)
                                .background(workoutColor.opacity(0.1))
                                .clipShape(Circle())
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        Text(post.name)
                            .font(.headline)
                        Text(post.date)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    Menu {
                        Button(action: {}) {
                            Label("Share Workout", systemImage: "square.and.arrow.up")
                        }
                        Button(action: {}) {
                            Label("Save to Collection", systemImage: "bookmark")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.gray)
                            .padding(8)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                ZStack(alignment: .bottomLeading) {
                    if post.workoutType == "Running" {
                        Image("runner_stock")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipped()
                            .overlay {
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .clear,
                                        workoutColor.opacity(0.7)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                    }
                    else if post.workoutType == "Biking" {
                        Image("stock_cycler")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipped()
                            .overlay {
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .clear,
                                        workoutColor.opacity(0.7)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                    } else {
                        Image("stock_swimmer")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 160)
                            .clipped()
                            .overlay {
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        .clear,
                                        workoutColor.opacity(0.7)
                                    ]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            }
                    }
                    
                    
                    HStack {
                        WorkoutTypeTag(type: post.workoutType, color: workoutColor)
                        Spacer()
                        if !post.routeLocations.isEmpty {
                            Image(systemName: "map.fill")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.white.opacity(0.2))
                                .clipShape(Circle())
                        }
                    }
                    .padding(16)
                }
                .onTapGesture(count: 2) {
                    withAnimation {
                        viewModel.toggleLike(for: post)
                        animateHeart = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        animateHeart = false
                    }
                }
                .overlay {
                    if animateHeart {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.white)
                            .transition(.scale)
                    }
                }

                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    StatItem(title: "Distance", value: "\(post.distance) mi", icon: "figure.run", color: workoutColor)
                    StatItem(title: "Heart Rate", value: post.averageHeartRate, icon: "heart.fill", color: .red)
                    StatItem(title: "Duration", value: post.duration, icon: "clock.fill", color: .orange)
                    StatItem(title: "Calories", value: "\(post.calories) kcal", icon: "flame.fill", color: .pink)
                }
                .padding()
                
                HStack(spacing: 20) {
                    Button(action: {
                        withAnimation {
                            viewModel.toggleLike(for: post)
                        }
                    }) {
                        HStack {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                            Text(isLiked ? "Liked" : "Like")
                            if !post.likes.isEmpty {
                                Text("(\(post.likes.count))")
                            }
                        }
                        .foregroundColor(isLiked ? .red : .gray)
                    }
                    
                    Button(action: { showingComments.toggle() }) {
                        HStack {
                            Image(systemName: "message")
                            Text("Comments")
                            if !post.comments.isEmpty {
                                Text("(\(post.comments.count))")
                            }
                        }
                        .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    ShareLink(item: "Check out this awesome workout!") {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isOwnPost ? Color.red.opacity(0.3) : Color.clear, lineWidth: 2)
            )
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isOwnPost ? Color.red.opacity(0.05) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingComments) {
            CommentsView(post: post, viewModel: viewModel)
        }
    }
}

struct CommentsView: View {
    let post: WorkoutPost
    @ObservedObject var viewModel: FeedViewModel
    @State private var newCommentText = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(post.comments) { comment in
                        CommentRow(comment: comment)
                    }
                }
                
                HStack {
                    TextField("Add a comment...", text: $newCommentText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                    
                    Button(action: {
                        guard !newCommentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                        viewModel.addComment(to: post, text: newCommentText)
                        newCommentText = ""
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.blue)
                    }
                    .padding(.trailing)
                }
                .padding(.vertical, 8)
                .background(Color(.systemBackground))
                .shadow(radius: 2)
            }
            .navigationTitle("Comments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

struct CommentRow: View {
    let comment: Comment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(comment.userName)
                .font(.headline)
            Text(comment.text)
                .font(.body)
            Text(comment.timestamp.formatted())
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? .blue : .gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WorkoutTypeTag: View {
    let type: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: type == "Running" ? "figure.run" :
                            type == "Biking" ? "figure.outdoor.cycle" :
                            type == "Swimming" ? "figure.pool.swim" : "figure.mixed.cardio")
            Text(type)
                .font(.system(size: 16, weight: .medium))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(color.opacity(0.3))
        .cornerRadius(20)
    }
}

struct StatItem: View {
    var title: String
    var value: String
    var icon: String
    var color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 32, height: 32)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            
            Text(value)
                .font(.system(size: 16, weight: .semibold))
                .minimumScaleFactor(0.8)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}
