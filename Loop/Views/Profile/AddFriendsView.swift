//
//  AddFriendsView.swift
//  Loop
//
//  Created by Jihoon Kim on 10/3/24.
//

import SwiftUI
// struct to add friend
// AddFriendRow.swift
struct AddFriendRow: View {
    var userId: String
    var friendName: String
    @State var friendId: String
    @ObservedObject var profileViewModel: ProfileViewModel

    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill").font(.system(size: 40)).foregroundColor(.gray)
            VStack(alignment: .leading) {
                Text(friendName).font(.headline)
            }
            Spacer()
            VStack {
                Button(action: {
                    print("friend added")
                    Task {
                        await profileViewModel.addFriend(userId: userId, friendId: friendId)
                    }
                }) {Image(systemName: "plus")
                        .font(.system(size: 24))
                        .padding()
                        .background(Color.blue)
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
struct AcceptFriendRow: View {
    var userId: String
    @State var friendName: String
    var friendId: String
    @ObservedObject var profileViewModel: ProfileViewModel

    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill").font(.system(size: 40)).foregroundColor(.gray)
            VStack(alignment: .leading) {
                Text(friendName).font(.headline)
            }
            Spacer()
            VStack {
                Button(action: {
                    print("friend added")
                    Task {
                        await profileViewModel.acceptFriend(userId: userId, friendId: friendId)
                    }
                }) {Image(systemName: "plus")
                        .font(.system(size: 24))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            VStack {
                Button(action: {
                    print("friend removed")
                    Task {
                        await profileViewModel.declineFriend(userId: userId, friendId: friendId)
                    }
                }) {Image(systemName: "xmark")
                        .font(.system(size: 24))
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }.padding().background(Color.white).cornerRadius(10).shadow(radius: 2).padding(.horizontal)
            .onAppear {
                Task {
                    friendName = await profileViewModel.getName(userId: friendId) ?? "Name"
                }
            }
    }
}

// AddFriendsView.swift
struct AddFriendsView: View {
    @State var user: User?
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var searchText: String = ""
    @State private var allUsers: [ProfileViewModel.Users] = []
    @State private var matchedFriends: [ProfileViewModel.Users] = []
    @State private var requestingFriends: [String] = []
    @Environment(\.presentationMode) var presentationMode
    let userId: String
    
    init(profileViewModel: ProfileViewModel, requestingFriends: [String], userId: String, user: User) {
        self.profileViewModel = profileViewModel
        self.requestingFriends = requestingFriends
        self.userId = userId
        self._user = State(initialValue: user)
        self._allUsers = State(initialValue: profileViewModel.users)  // Ensure users are passed and available
    }
    
    private func filterFriends() {
        if searchText.isEmpty {
            matchedFriends = allUsers
        } else {
            matchedFriends = allUsers.filter { user in
                user.name.lowercased().contains(searchText.lowercased()) && !user.name.contains("1")
            }
        }
    }
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left.circle.fill").font(.system(size: 30)).foregroundColor(.orange)
                }
                
                Spacer()
                
                Text("Add Friends").font(.headline)
                
                Spacer()
            }
            .padding()
            
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search Friends", text: $searchText)
                    .padding(8)
                    .background(Color.orange.opacity(0.3))
                    .cornerRadius(8)
                    .onChange(of: searchText) { _ in filterFriends() }
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                ScrollView {
                    ForEach(matchedFriends, id: \.id) { friend in
                        AddFriendRow(userId: userId, friendName: friend.name, friendId: friend.id, profileViewModel: profileViewModel)
                    }
                }
            }
            .padding(.top)
            
            VStack(alignment: .leading) {
                Text("Incoming Requests: ").font(.subheadline).padding(.leading)
                ScrollView {
                    ForEach(requestingFriends, id: \.self) { friend in
                        AcceptFriendRow(userId: userId,friendName: "Name", friendId: friend, profileViewModel: profileViewModel)
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task {
                // Fetch all users asynchronously if not already fetched
                allUsers = profileViewModel.users
            }
        }
    }
}
    
