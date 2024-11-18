//
//  ManageFriendsView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Friend {
    var name: String
    var username: String
    var userId: String
    var profileImage: String
}

struct FriendRow: View {
    var friendName: String
    var username: String
    var userId: String
    var profileImage: String
    
    var body: some View {
        HStack {
            NavigationLink(destination: FriendProfileView(userId: userId)) {
                if User.shared.profilePictureId.isEmpty || User.shared.profilePictureId == "None" {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    if let url = URL(string: profileImage) {
                        AsyncImage(url: url) { image in
                            image.resizable().frame(width: 50, height: 50).clipShape(.circle)
                        } placeholder: {
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                                Image(systemName: "person.circle")
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(.white)
                            }
                        }

                    }
                }
                VStack(alignment: .leading) {
                    Text(friendName).font(.headline)
                    Text(username).font(.caption).foregroundColor(.gray)
                }
                Spacer()
            }.padding().background(Color.white).cornerRadius(10).shadow(radius: 2).padding(.horizontal)
        }
    }
}

struct ManageFriendsView: View {
    @State var userId: String
    @State var friends: [String] = []
    @State private var searchText: String = ""
    @State private var allUsers: [Friend] = []
    @State private var allFriends: [Friend] = []
    @State private var filteredFriends: [Friend] = []
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State private var showingErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    private let db = Firestore.firestore()
    
    
    private func filterFriends() {
        if searchText.isEmpty {
            filteredFriends = allFriends
        } else {
            filteredFriends = allFriends.filter { friend in
                friend.name.lowercased().contains(searchText.lowercased())
            }
        }
        }
    
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
            self.allUsers = documents.compactMap { doc -> (Friend)? in
                let data = doc.data()
                guard let name = data["name"] as? String else { return nil }
                guard let username = data["username"] as? String else {return nil}
                guard let profileImage = data["profilePictureId"] as? String else { return nil }
                let uid = doc.documentID
                if uid == userId { return nil }  // Exclude current user
                if !friends.contains(uid) {return nil}
                return Friend(name: name, username: username, userId: uid, profileImage: profileImage)
            }

            // Update allFriends based on fetched users
            DispatchQueue.main.async {
                self.allFriends = self.allUsers.map { user in
                    Friend(name: user.name, username: user.username, userId: user.userId, profileImage: user.profileImage)
                }
                self.filterFriends()
            }
        }
    }

        var body: some View {
        VStack {
            // Back Button + Header
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "arrow.left.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.red)
                }
                Spacer()
                Text("Manage Friends").font(.headline)
                Spacer()
            }
            .padding()

            // Search Bar
            TextField("Search Friends", text: $searchText)
                .padding(8)
                .background(Color.red.opacity(0.3))
                .cornerRadius(8)
                .padding(.horizontal)
                .onChange(of: searchText) { _ in filterFriends() }

            // Friends List
            ScrollView {
                ForEach(filteredFriends, id: \.userId) { friend in
                    FriendRow(friendName: friend.name, username: friend.username, userId: friend.userId, profileImage: friend.profileImage)
                }
            }
            .padding(.top)

            Spacer()
        }
        .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .onAppear { filterFriends()
            fetchUsers()}
    }
}

#Preview {
    //ManageFriendsView()
}
