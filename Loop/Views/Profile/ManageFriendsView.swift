//
//  ManageFriendsView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct FriendRow: View {
    var friendName: String
    var friendID: String
    var friendAvatar: String?
    
    var body: some View {
        HStack {
            NavigationLink(destination: FriendProfileView(name: friendName)) {
                Image(systemName: "person.circle.fill").font(.system(size: 40)).foregroundColor(.gray)
                VStack(alignment: .leading) {
                    Text(friendName).font(.headline)
                }
                Spacer()
            }.padding().background(Color.white).cornerRadius(10).shadow(radius: 2).padding(.horizontal)
        }
    }
}


struct ManageFriendsView: View {
    @ObservedObject var profileViewModel: ProfileViewModel
    @State private var searchText: String = ""
    @State private var allFriends: [ProfileViewModel.Friend] = []
    @State private var filteredFriends: [ProfileViewModel.Friend] = []
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss 
    
    init(profileViewModel: ProfileViewModel) {
        self.profileViewModel = profileViewModel
        self.allFriends = profileViewModel.friends
    }
    
    private func filterFriends() {
        if searchText.isEmpty {
            filteredFriends = allFriends
        } else {
            filteredFriends = allFriends.filter { friend in
                friend.name.lowercased().contains(searchText.lowercased())
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
                ForEach(filteredFriends, id: \.id) { friend in
                    FriendRow(friendName: friend.name, friendID: friend.id, friendAvatar: friend.avatar)
                }
            }
            .padding(.top)

            
        }
        .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .onAppear { filterFriends() }
    }
}

#Preview {
   
}
