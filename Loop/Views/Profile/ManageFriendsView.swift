//
//  ManageFriendsView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct FriendRow: View {
    var friendName: String
    var username: String
    
    var body: some View {
        HStack {
            NavigationLink(destination: FriendProfileView(name: friendName)) {
                Image(systemName: "person.circle.fill").font(.system(size: 40)).foregroundColor(.gray)
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
    @State private var allUsers: [(uid: String, name: String)] = []
    @State private var allFriends: [String] = []
    @State private var filteredFriends: [String] = []
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State private var showingErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    private let db = Firestore.firestore()
    
    
    private func filterFriends() {
            if searchText.isEmpty {
                filteredFriends = allFriends
            } else {
                filteredFriends = allFriends.filter {
                    $0.lowercased().contains(searchText.lowercased())
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
            self.allUsers = documents.compactMap { doc -> (uid: String, name: String)? in
                let data = doc.data()
                guard let name = data["name"] as? String else { return nil }
                let uid = doc.documentID
                if uid == userId { return nil }  // Exclude current user
                if !friends.contains(uid) {return nil}
                return (uid: uid, name: name)
            }

            // Update allFriends based on fetched users
            DispatchQueue.main.async {
                self.allFriends = self.allUsers.map { $0.name }
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
                ForEach(filteredFriends, id: \.self) { friend in
                    FriendRow(friendName: friend, username: "")
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
