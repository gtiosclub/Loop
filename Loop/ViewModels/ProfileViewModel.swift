//
//  ProfileViewModel.swift
//  Loop
//
//  Created by Jihoon Kim on 11/14/24.
//

// DEPRICATED

/*
import SwiftUI
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var selfPosts: [WorkoutPost] = []
    private let db = Firestore.firestore()
    let currentUserId: String
    
    init(currentUserId: String) {
        self.currentUserId = currentUserId
    }

    func fetchSelfPosts(for userId: String) {
        self.selfPosts = []
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                let name = userData?["name"] as? String ?? "Unknown"
                let avatar = userData?["profilePictureId"] as? String ?? "person.crop.circle"
                
                // Fetch user's workouts with social data
                self?.fetchWorkouts(userId: userId, name: name, avatar: avatar)
            } else {
                print("User document does not exist.")
            }
        }
    }

    private func fetchWorkouts(userId: String, name: String, avatar: String) {
        db.collection("users").document(userId).collection("workouts")
            .order(by: "endDate", descending: true)
            .getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error fetching workouts: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                for document in documents {
                    self?.fetchWorkoutWithSocialData(document, userName: name, userAvatar: avatar, userId: userId)
                }
            }
    }
    
    private func fetchWorkoutWithSocialData(_ document: QueryDocumentSnapshot, userName: String, userAvatar: String, userId: String) {
        let workoutRef = document.reference
        
        // Create dispatch group for parallel fetching
        let group = DispatchGroup()
        
        var likes: [String] = []
        var comments: [Comment] = []
        
        // Fetch likes
        group.enter()
        workoutRef.collection("likes").getDocuments { snapshot, error in
            defer { group.leave() }
            if let documents = snapshot?.documents {
                likes = documents.compactMap { $0.documentID }
            }
        }
        
        // Fetch comments
        group.enter()
        workoutRef.collection("comments")
            .order(by: "timestamp", descending: false)
            .getDocuments { snapshot, error in
                defer { group.leave() }
                if let documents = snapshot?.documents {
                    comments = documents.compactMap { document in
                        guard let userId = document.data()["userId"] as? String,
                              let userName = document.data()["userName"] as? String,
                              let text = document.data()["text"] as? String,
                              let timestamp = (document.data()["timestamp"] as? Timestamp)?.dateValue()
                        else { return nil }
                        
                        return Comment(
                            id: document.documentID,
                            userId: userId,
                            userName: userName,
                            text: text,
                            timestamp: timestamp
                        )
                    }
                }
            }
        
        // When both likes and comments are fetched, create the post
        group.notify(queue: .main) { [weak self] in
            self?.createWorkoutPost(
                from: document,
                userName: userName,
                userAvatar: userAvatar,
                likes: likes,
                comments: comments,
                userId: userId
            )
        }
    }

    private func createWorkoutPost(
        from document: QueryDocumentSnapshot,
        userName: String,
        userAvatar: String,
        likes: [String],
        comments: [Comment],
        userId: String
    ) {
        let data = document.data()
        
        let workoutType = data["workoutType"] as? String ?? "Workout"
        let totalDistance = data["totalDistance"] as? Double ?? 0.0
        let totalEnergyBurned = data["totalEnergyBurned"] as? Double ?? 0.0
        let averageHeartRate = data["averageHeartRate"] as? Double ?? 0.0

        var heartRatePoints: [HeartRateEntry] = []
        if let hrPoints = data["heartRatePoints"] as? [[String: Any]] {
            for hrPoint in hrPoints {
                if let timestamp = hrPoint["date"] as? Timestamp,
                   let value = hrPoint["value"] as? Double {
                    let date = timestamp.dateValue()
                    let entry = HeartRateEntry(date: date, value: value)
                    heartRatePoints.append(entry)
                }
            }
        }

        var routeLocations: [RouteLocation] = []
        if let locations = data["routeLocations"] as? [[String: Any]] {
            for location in locations {
                if let latitude = location["latitude"] as? Double,
                   let longitude = location["longitude"] as? Double {
                    let routeLocation = RouteLocation(latitude: latitude, longitude: longitude)
                    routeLocations.append(routeLocation)
                }
            }
        }

        if let startDate = (data["startDate"] as? Timestamp)?.dateValue(),
           let endDate = (data["endDate"] as? Timestamp)?.dateValue() {
            let durationInSeconds = endDate.timeIntervalSince(startDate)
            let duration = Self.formatDuration(durationInSeconds)
            let date = Self.formatDate(endDate)

            let newPost = WorkoutPost(
                id: document.documentID,
                name: userName,
                avatar: userAvatar,
                workoutType: workoutType,
                distance: String(format: "%.2f", totalDistance),
                pace: "-",
                duration: duration,
                calories: String(format: "%.0f", totalEnergyBurned),
                date: date,
                averageHeartRate: String(format: "%.0f bpm", averageHeartRate),
                heartRatePoints: heartRatePoints,
                routeLocations: routeLocations,
                timestamp: endDate,
                likes: likes,
                comments: comments,
                userId: userId
            )

            DispatchQueue.main.async {
                if let index = self.selfPosts.firstIndex(where: { $0.id == newPost.id }) {
                    self.selfPosts[index] = newPost
                } else {
                    self.selfPosts.append(newPost)
                    self.selfPosts.sort { $0.timestamp > $1.timestamp }
                }
            }
        }
    }
    
    // MARK: - Social Interactions
    
    func toggleLike(for post: WorkoutPost) {
        let workoutRef = db.collection("users")
            .document(post.userId)
            .collection("workouts")
            .document(post.id)
        
        let likeRef = workoutRef.collection("likes").document(currentUserId)
        
        if post.likes.contains(currentUserId) {
            // Unlike
            likeRef.delete { [weak self] error in
                if error == nil {
                    self?.updateLocalLikes(for: post, removing: self?.currentUserId)
                }
            }
        } else {
            // Like
            likeRef.setData([:]) { [weak self] error in
                if error == nil {
                    self?.updateLocalLikes(for: post, adding: self?.currentUserId)
                }
            }
        }
    }
    
    private func updateLocalLikes(for post: WorkoutPost, adding userId: String? = nil, removing removeId: String? = nil) {
        if let index = selfPosts.firstIndex(where: { $0.id == post.id }) {
            var updatedPost = post
            
            if let addId = userId {
                updatedPost.likes.append(addId)
            }
            if let removeId = removeId {
                updatedPost.likes.removeAll(where: { $0 == removeId })
            }
            
            selfPosts[index] = updatedPost
        }
    }
    
    func addComment(to post: WorkoutPost, text: String) {
        // First fetch the current user's name
        db.collection("users").document(currentUserId).getDocument { [weak self] snapshot, error in
            guard let self = self,
                  let data = snapshot?.data(),
                  let userName = data["name"] as? String else { return }
            
            let workoutRef = db.collection("users")
                .document(post.userId)
                .collection("workouts")
                .document(post.id)
            
            let commentData: [String: Any] = [
                "userId": self.currentUserId,
                "userName": userName,
                "text": text,
                "timestamp": Timestamp()
            ]
            
            workoutRef.collection("comments").addDocument(data: commentData) { [weak self] error in
                if error == nil {
                    let newComment = Comment(
                        id: UUID().uuidString,
                        userId: self?.currentUserId ?? "",
                        userName: userName,
                        text: text,
                        timestamp: Date()
                    )
                    self?.updateLocalComments(for: post, adding: newComment)
                }
            }
        }
    }
    
    private func updateLocalComments(for post: WorkoutPost, adding comment: Comment) {
        if let index = selfPosts.firstIndex(where: { $0.id == post.id }) {
            var updatedPost = post
            updatedPost.comments.append(comment)
            selfPosts[index] = updatedPost
        }
    }

    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }

    private static func formatDuration(_ durationInSeconds: TimeInterval) -> String {
        let hours = Int(durationInSeconds) / 3600
        let minutes = (Int(durationInSeconds) % 3600) / 60
        let seconds = Int(durationInSeconds) % 60

        if hours > 0 {
            return "\(hours)h \(minutes)m \(seconds)s"
        } else if minutes > 0 {
            return "\(minutes)m \(seconds)s"
        } else {
            return "\(seconds)s"
        }
    }
}

*/
