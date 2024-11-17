import SwiftUI
import FirebaseFirestore

struct HeartRateEntry: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

struct RouteLocation: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
}

struct Comment: Identifiable {
    let id: String
    let userId: String
    let userName: String
    let text: String
    let timestamp: Date
}

struct WorkoutPost: Identifiable {
    let id: String
    let name: String
    let avatar: String
    let workoutType: String
    let distance: String
    let pace: String
    let duration: String
    let calories: String
    let date: String
    let averageHeartRate: String
    let heartRatePoints: [HeartRateEntry]
    let routeLocations: [RouteLocation]
    let timestamp: Date
    var likes: [String]
    var comments: [Comment]
    let userId: String
}

class FeedViewModel: ObservableObject {
    @Published var friendPosts: [WorkoutPost] = []
    private let db = Firestore.firestore()
    let currentUserId: String
    
    init(currentUserId: String) {
        self.currentUserId = currentUserId
    }

    func fetchFriendPosts(for userId: String) {
        self.friendPosts = []
        
        // First fetch current user's posts
        fetchCurrentUserPosts(userId)
        
        // Then fetch friends' posts
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                if let friends = document.data()?["friends"] as? [String], !friends.isEmpty {
                    self?.fetchActivitiesForFriends(friends)
                } else {
                    print("No friends found or 'friends' field is missing.")
                }
            } else {
                print("User document does not exist.")
            }
        }
    }
    
    private func fetchCurrentUserPosts(_ userId: String) {
        db.collection("users").document(userId).getDocument { [weak self] (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                let name = userData?["name"] as? String ?? "Unknown"
                let avatar = userData?["profilePictureId"] as? String ?? "person.crop.circle"
                
                // Fetch user's own workouts
                self?.fetchActivitiesForFriend(friendId: userId, name: name, avatar: avatar)
            }
        }
    }

    private func fetchActivitiesForFriends(_ friendUids: [String]) {
        let chunks = friendUids.chunked(into: 10)
        for chunk in chunks {
            db.collection("users")
                .whereField("uid", in: chunk)
                .getDocuments { [weak self] (snapshot, error) in
                    if let error = error {
                        print("Error fetching user documents: \(error)")
                        return
                    }

                    guard let userDocs = snapshot?.documents else { return }

                    for userDoc in userDocs {
                        let userData = userDoc.data()
                        let friendId = userDoc.documentID
                        let name = userData["name"] as? String ?? "Unknown"
                        let avatar = userData["profilePictureId"] as? String ?? "person.crop.circle"

                        self?.fetchActivitiesForFriend(friendId: friendId, name: name, avatar: avatar)
                    }
                }
        }
    }

    private func fetchActivitiesForFriend(friendId: String, name: String, avatar: String) {
        db.collection("users").document(friendId).collection("workouts")
            .getDocuments { [weak self] (snapshot, error) in
                if let error = error {
                    print("Error fetching activities for friend \(friendId): \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                for document in documents {
                    self?.fetchWorkoutWithSocialData(document, friendName: name, friendAvatar: avatar, friendId: friendId)
                }
            }
    }
    
    private func fetchWorkoutWithSocialData(_ document: QueryDocumentSnapshot, friendName: String, friendAvatar: String, friendId: String) {
        let workoutRef = document.reference
        let group = DispatchGroup()
        
        var likes: [String] = []
        var comments: [Comment] = []
        
        group.enter()
        workoutRef.collection("likes").getDocuments { snapshot, error in
            defer { group.leave() }
            if let documents = snapshot?.documents {
                likes = documents.compactMap { $0.documentID }
            }
        }
        
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
        
        group.notify(queue: .main) { [weak self] in
            self?.createWorkoutPost(
                from: document,
                friendName: friendName,
                friendAvatar: friendAvatar,
                likes: likes,
                comments: comments,
                userId: friendId
            )
        }
    }

    private func createWorkoutPost(
        from document: QueryDocumentSnapshot,
        friendName: String,
        friendAvatar: String,
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
                name: friendName,
                avatar: friendAvatar,
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
                if let index = self.friendPosts.firstIndex(where: { $0.id == newPost.id }) {
                    self.friendPosts[index] = newPost
                } else {
                    self.friendPosts.append(newPost)
                    self.friendPosts.sort { $0.timestamp > $1.timestamp }
                }
            }
        }
    }
    
    func toggleLike(for post: WorkoutPost) {
        let workoutRef = db.collection("users")
            .document(post.userId)
            .collection("workouts")
            .document(post.id)
        
        let likeRef = workoutRef.collection("likes").document(currentUserId)
        
        if post.likes.contains(currentUserId) {
            likeRef.delete { [weak self] error in
                if error == nil {
                    self?.updateLocalLikes(for: post, removing: self?.currentUserId)
                }
            }
        } else {
            likeRef.setData([:]) { [weak self] error in
                if error == nil {
                    self?.updateLocalLikes(for: post, adding: self?.currentUserId)
                }
            }
        }
    }
    
    private func updateLocalLikes(for post: WorkoutPost, adding userId: String? = nil, removing removeId: String? = nil) {
        if let index = friendPosts.firstIndex(where: { $0.id == post.id }) {
            var updatedPost = post
            
            if let addId = userId {
                updatedPost.likes.append(addId)
            }
            if let removeId = removeId {
                updatedPost.likes.removeAll(where: { $0 == removeId })
            }
            
            friendPosts[index] = updatedPost
        }
    }
    
    func addComment(to post: WorkoutPost, text: String) {
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
        if let index = friendPosts.firstIndex(where: { $0.id == post.id }) {
            var updatedPost = post
            updatedPost.comments.append(comment)
            friendPosts[index] = updatedPost
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

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        var chunks = [[Element]]()
        var index = self.startIndex
        while index < self.endIndex {
            let chunkEnd = index.advanced(by: size)
            let limitedChunkEnd = Swift.min(chunkEnd, endIndex)
            chunks.append(Array(self[index..<limitedChunkEnd]))
            index = limitedChunkEnd
        }
        return chunks
    }
}
