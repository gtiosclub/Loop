//
//  ManageFriendsView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct FriendRow: View {
    var friendName: String
    var status: String
    
    var body: some View {
        HStack {
            NavigationLink(destination: FriendProfileView()) {
                Image(systemName: "person.circle.fill").font(.system(size: 40)).foregroundColor(.gray)
                VStack(alignment: .leading) {
                    Text(friendName).font(.headline)
                    Text(status).font(.caption).foregroundColor(.gray)
                }
                Spacer()
            }.padding().background(Color.white).cornerRadius(10).shadow(radius: 2).padding(.horizontal)
        }
    }
}

struct ManageFriendsView: View {
    @State private var searchText: String = ""
    @State private var onlineFriends: [String] = ["Kevin", "Ethan", "Jason"]
    @State private var offlineFriends: [String] = ["Kevin", "Ethan", "Jason", "Seohyun", "Dennis", "Aryun", "Dennis", "Dennis", "Dennis"]
    @State private var allFriends: [String] = ["Kevin", "Ethan", "Jason", "Seohyun", "Dennis", "Aryun", "Dennis", "Dennis", "Dennis"]
    @State private var filteredFriends: [String] = []
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    
    
    private func filterFriends() {
            if searchText.isEmpty {
                filteredFriends = allFriends
            } else {
                filteredFriends = allFriends.filter {
                    $0.lowercased().contains(searchText.lowercased())
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
                        .foregroundColor(.orange)
                }
                Spacer()
                Text("Manage Friends").font(.headline)
                Spacer()
            }
            .padding()

            // Search Bar
            TextField("Search Friends", text: $searchText)
                .padding(8)
                .background(Color.orange.opacity(0.3))
                .cornerRadius(8)
                .padding(.horizontal)
                .onChange(of: searchText) { _ in filterFriends() }

            // Friends List
            ScrollView {
                ForEach(filteredFriends, id: \.self) { friend in
                    FriendRow(friendName: friend, status: "")
                }
            }
            .padding(.top)

            Spacer()
        }
        .background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all))
        .navigationBarBackButtonHidden(true)
        .onAppear { filterFriends() }
    }
}

#Preview {
    ManageFriendsView()
}
