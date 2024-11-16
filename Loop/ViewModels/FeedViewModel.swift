import SwiftUI
import FirebaseFirestore

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
}

class FeedViewModel: ObservableObject {
    @Published var friendPosts: [WorkoutPost] = []
    private let db = Firestore.firestore()

    func fetchFriendPosts(for userId: String) {
        self.friendPosts = []
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
                        let uid = userData["uid"] as? String ?? ""
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
                    self?.createWorkoutPost(from: document, friendName: name, friendAvatar: avatar)
                }
            }
    }

    private func createWorkoutPost(from document: QueryDocumentSnapshot, friendName: String, friendAvatar: String) {
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
                routeLocations: routeLocations
            )

            DispatchQueue.main.async {
                self.friendPosts.append(newPost)
            }
        } else {
            print("Start date or end date is missing in activity document.")
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
            let chunkEnd = index + size
            let limitedChunkEnd = chunkEnd > self.endIndex ? self.endIndex : chunkEnd
            chunks.append(Array(self[index..<limitedChunkEnd]))
            index = limitedChunkEnd
        }

        return chunks
    }
}

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

