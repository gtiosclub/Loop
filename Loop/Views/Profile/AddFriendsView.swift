//
//  AddFriendsView.swift
//  Loop
//
//  Created by Jihoon Kim on 10/3/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

// MARK: - AddFriendRow View
struct AddFriendRow: View {
    var friendName: String
    var status: String
    var isRequestSent: Bool
    var onAdd: (() -> Void)? = nil  // Optional closure for add action

    var body: some View {
        HStack {
            // User Avatar
            Image(systemName: "person.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            // User Information
            VStack(alignment: .leading) {
                Text(friendName)
                    .font(.headline)
                Text(status)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Add Button or Pending Indicator
            VStack {
                Button(action: {
                    onAdd?()  // Trigger add action
                }) {
                    if isRequestSent {
                        // Pending State
                        Text("Pending")
                            .font(.system(size: 14))
                            .padding(8)
                            .background(Color.gray.opacity(0.3))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    } else {
                        // Add Friend Button
                        Image(systemName: "plus")
                            .font(.system(size: 24))
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                    }
                }
                .disabled(isRequestSent)  // Disable button if request sent
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

// MARK: - AcceptFriendRow View
struct AcceptFriendRow: View {
    var friendName: String
    var status: String
    var onAccept: (() -> Void)? = nil  // Optional closure for accept action
    var onDecline: (() -> Void)? = nil // Optional closure for decline action

    var body: some View {
        HStack {
            // User Avatar
            Image(systemName: "person.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.gray)
            
            // User Information
            VStack(alignment: .leading) {
                Text(friendName)
                    .font(.headline)
                Text(status)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Accept Button
            VStack {
                Button(action: {
                    onAccept?()  // Trigger accept action
                }) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 24))
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            
            // Decline Button
            VStack {
                Button(action: {
                    onDecline?() // Trigger decline action
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 24))
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

// MARK: - AddFriendsView
struct AddFriendsView: View {
    // Search and Friend Lists
    @State private var searchText: String = ""
    @State private var allFriends: [String] = []           // All available friends fetched from Firestore
    @State private var requestingFriends: [String] = []    // Incoming requests
    @State private var matchedFriends: [String] = []        // Filtered friends based on search
    @Environment(\.presentationMode) var presentationMode

    // Firestore User Data
    @State private var allUsers: [(uid: String, name: String)] = []
    @State private var currentUserUID: String = ""
    @State var userId: String
    
    // Sent Friend Requests Tracking
    @State private var sentRequests: Set<String> = []

    // Firestore Reference
    private let db = Firestore.firestore()

    // Error Handling States
    @State private var showingErrorAlert: Bool = false
    @State private var errorMessage: String = ""

    // MARK: - Unique User ID Generation
    private func getCurrentUserUID() -> String {
        if let uid = UserDefaults.standard.string(forKey: "currentUserUID") {
            return uid
        } else {
            let uid = UUID().uuidString
            UserDefaults.standard.set(uid, forKey: "currentUserUID")
            return uid
        }
    }

    // MARK: - Ensure "Me" Document Exists in Firestore
    private func ensureUserDocumentExists() {
        let userRef = db.collection("users").document(userId)
        userRef.getDocument { snapshot, error in
            if let error = error {
                print("Error checking user document: \(error.localizedDescription)")
                self.errorMessage = "Failed to verify user data."
                self.showingErrorAlert = true
                return
            }

            if snapshot?.exists == false {
                // Create a new user document with default fields
                userRef.setData([
                    "name": "Me",
                    "incomingRequests": [],
                    "friends": []
                ]) { error in
                    if let error = error {
                        print("Error creating user document: \(error.localizedDescription)")
                        self.errorMessage = "Failed to initialize your user data."
                        self.showingErrorAlert = true
                    } else {
                        print("User document created successfully.")
                    }
                }
            } else {
                print("User document already exists.")
            }
        }
    }

    // MARK: - Filter Friends Based on Search Text
    private func filterFriends() {
        if searchText.isEmpty {
            // When search is empty, show no friends
            matchedFriends = []
        } else {
            // Filter friends by search text (case-insensitive)
            matchedFriends = allFriends.filter {
                $0.lowercased().contains(searchText.lowercased()) && !$0.contains("1")
            }
        }
    }

    var body: some View {
        VStack {
            // Header with Back Button and Title
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.red)
                }

                Spacer()

                Text("Add Friends")
                    .font(.headline)

                Spacer()

                // Invisible image for symmetry
                Image(systemName: "arrow.left.circle.fill")
                    .opacity(0)
            }
            .padding()

            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search Friends", text: $searchText)
                    .padding(8)
                    .background(Color.red.opacity(0.3))
                    .cornerRadius(8)
                    .onChange(of: searchText) { _ in
                        filterFriends()
                    }
            }
            .padding(.horizontal)
            VStack(alignment: .leading) {
                if matchedFriends.isEmpty && !searchText.isEmpty {
                    Text("No users found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView {
                        ForEach(matchedFriends, id: \.self) { friend in
                            // Determine if a request has been sent to this friend
                            let isRequestSent = sentRequests.contains(friend)
                            AddFriendRow(friendName: friend, status: "Now Active", isRequestSent: isRequestSent) {
                                addFriend(to: friend)
                            }
                        }
                    }
                }
            }
            .padding(.top)

            // Incoming Requests Section
            VStack(alignment: .leading) {
                Text("Incoming Requests:")
                    .font(.subheadline)
                    .padding(.leading)

                if requestingFriends.isEmpty {
                    Text("No incoming requests")
                        .foregroundColor(.gray)
                        .padding(.leading)
                } else {
                    ScrollView {
                        ForEach(requestingFriends, id: \.self) { friend in
                            AcceptFriendRow(friendName: friend, status: "Last Seen: 7 days") {
                                acceptFriend(userName: friend)
                            } onDecline: {
                                declineFriend(userName: friend)
                            }
                        }
                    }
                }
            }
            .padding(.top)

            Spacer()
        }
        .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showingErrorAlert) {
            Alert(title: Text("Notification"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            // Generate or retrieve the current user's UID
            self.currentUserUID = getCurrentUserUID()
            // Ensure the current user's document exists in Firestore
            ensureUserDocumentExists()
            // Fetch all users from Firestore
            fetchUsers()
            // Fetch incoming friend requests
            fetchIncomingRequests()
        }
    }

    // MARK: - Fetch All Users from Firestore
    private func fetchUsers() {
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching users: \(error.localizedDescription)")
                self.errorMessage = "Failed to fetch users."
                self.showingErrorAlert = true
                return
            }

            guard let documents = snapshot?.documents else {
                print("No users found")
                return
            }

            // Populate allUsers with tuples excluding current user
            self.allUsers = documents.compactMap { doc -> (uid: String, name: String)? in
                let data = doc.data()
                guard let name = data["name"] as? String else { return nil }
                let uid = doc.documentID
                if uid == currentUserUID { return nil }  // Exclude current user
                return (uid: uid, name: name)
            }

            // Update allFriends based on fetched users
            DispatchQueue.main.async {
                self.allFriends = self.allUsers.map { $0.name }
                self.filterFriends()
            }
        }
    }

    // MARK: - Fetch Incoming Friend Requests
    private func fetchIncomingRequests() {
        let userRef = db.collection("users").document(userId)
        userRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching incoming requests: \(error.localizedDescription)")
                self.errorMessage = "Failed to fetch incoming requests."
                self.showingErrorAlert = true
                return
            }

            guard let data = snapshot?.data(),
                  let requestIDs = data["incomingRequests"] as? [String],
                  !requestIDs.isEmpty else {
                print("No incoming requests")
                return
            }

            // Firestore 'in' queries require at least one element and max 10 elements
            // Split into batches if necessary
            let batches = stride(from: 0, to: requestIDs.count, by: 10).map {
                Array(requestIDs[$0..<min($0 + 10, requestIDs.count)])
            }

            for batch in batches {
                db.collection("users").whereField(FieldPath.documentID(), in: batch).getDocuments { snapshot, error in
                    if let error = error {
                        print("Error fetching request users: \(error.localizedDescription)")
                        self.errorMessage = "Failed to fetch some incoming requests."
                        self.showingErrorAlert = true
                        return
                    }

                    guard let documents = snapshot?.documents else {
                        print("No request users found")
                        return
                    }

                    let fetchedRequestingFriends = documents.compactMap { doc -> String? in
                        let data = doc.data()
                        guard let name = data["name"] as? String else { return nil }
                        return name
                    }

                    DispatchQueue.main.async {
                        self.requestingFriends = fetchedRequestingFriends
                    }
                }
            }
        }
    }

    // MARK: - Add Friend Action
    private func addFriend(to friendName: String) {
        guard let friend = allUsers.first(where: { $0.name == friendName }) else {
            print("Friend not found")
            self.errorMessage = "Friend not found."
            self.showingErrorAlert = true
            return
        }

        // Prevent sending multiple requests to the same user
        if sentRequests.contains(friendName) {
            self.errorMessage = "Friend request already sent to \(friendName)."
            self.showingErrorAlert = true
            return
        }

        let userRef = db.collection("users").document(friend.uid)
        userRef.updateData([
            "incomingRequests": FieldValue.arrayUnion([userId])
        ]) { error in
            if let error = error {
                print("Error adding friend request: \(error.localizedDescription)")
                self.errorMessage = "Failed to send friend request to \(friendName)."
                self.showingErrorAlert = true
            } else {
                print("Friend request sent to \(friendName)")
                // Update the local state to reflect the sent request
                DispatchQueue.main.async {
                    self.sentRequests.insert(friendName)
                }
                // Provide user feedback via alert
                self.errorMessage = "Friend request sent to \(friendName)."
                self.showingErrorAlert = true
            }
        }
    }

    // MARK: - Accept Friend Action
    private func acceptFriend(userName: String) {
        guard let friend = allUsers.first(where: { $0.name == userName }) else {
            print("Friend not found")
            self.errorMessage = "Friend not found."
            self.showingErrorAlert = true
            return
        }

        let currentUserRef = db.collection("users").document(userId)
        let otherUserRef = db.collection("users").document(friend.uid)

        db.runTransaction({ (transaction, errorPointer) -> Any? in
            // Fetch the current user document
            guard let currentUserDocument = try? transaction.getDocument(currentUserRef),
                  let otherUserDocument = try? transaction.getDocument(otherUserRef) else {
                let error = NSError(domain: "AddFriendsView", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch documents."])
                errorPointer?.pointee = error
                return nil
            }

            // Add each other to friends list
            transaction.updateData([
                "friends": FieldValue.arrayUnion([friend.uid])
            ], forDocument: currentUserRef)

            transaction.updateData([
                "friends": FieldValue.arrayUnion([userId])
            ], forDocument: otherUserRef)

            // Remove from incomingRequests
            transaction.updateData([
                "incomingRequests": FieldValue.arrayRemove([friend.uid])
            ], forDocument: currentUserRef)

            return nil
        }) { (_, error) in
            if let error = error {
                print("Transaction failed: \(error)")
                self.errorMessage = "Failed to accept friend request from \(userName)."
                self.showingErrorAlert = true
            } else {
                print("Friend request accepted")
                // Provide user feedback via alert
                self.errorMessage = "You are now friends with \(userName)."
                self.showingErrorAlert = true
                // Remove the user from incomingRequests locally
                DispatchQueue.main.async {
                    if let index = self.requestingFriends.firstIndex(of: userName) {
                        self.requestingFriends.remove(at: index)
                    }
                }
            }
        }
    }

    // MARK: - Decline Friend Action
    private func declineFriend(userName: String) {
        guard let friend = allUsers.first(where: { $0.name == userName }) else {
            print("Friend not found")
            self.errorMessage = "Friend not found."
            self.showingErrorAlert = true
            return
        }

        let userRef = db.collection("users").document(userId)
        userRef.updateData([
            "incomingRequests": FieldValue.arrayRemove([friend.uid])
        ]) { error in
            if let error = error {
                print("Error declining friend request: \(error.localizedDescription)")
                self.errorMessage = "Failed to decline friend request from \(userName)."
                self.showingErrorAlert = true
            } else {
                print("Friend request from \(userName) declined")
                // Provide user feedback via alert
                self.errorMessage = "Friend request from \(userName) declined."
                self.showingErrorAlert = true
                // Update the incomingRequests list locally
                DispatchQueue.main.async {
                    if let index = self.requestingFriends.firstIndex(of: userName) {
                        self.requestingFriends.remove(at: index)
                    }
                }
            }
        }
    }
}

// MARK: - Preview
struct AddFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        AddFriendsView(userId: "7HeVe5w1fMO20fM2wDBgX0JslhH3")
    }
}
