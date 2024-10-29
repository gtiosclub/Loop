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
            NavigationLink(destination: FriendProfileView(name: friendName)) {
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
    @State private var offlineFriends: [String] = ["Kevin", "Ethan", "Jason", "Seohyun", "Dennis", "Aryun", "John"]
    @State private var allFriends: [String] = ["Kevin", "Ethan", "Jason", "Seohyun", "Dennis", "Aryun", "Dennis", "Dennis", "Dennis"]
    @State private var filteredFriends: [String] = []
    @Environment(\.presentationMode) var presentationMode
    
    
    private func filterFriends() {
        if searchText.isEmpty {
            // When search is empty, reset to the original friends list
            onlineFriends = allFriends.filter { $0.contains("1") }  // Example to filter for "Online" friends
            offlineFriends = allFriends.filter { !$0.contains("1") }  // Example to filter for "Offline" friends
        } else {
            // Filter friends by search text
            onlineFriends = allFriends.filter { $0.lowercased().contains(searchText.lowercased()) && $0.contains("1") }
            offlineFriends = allFriends.filter { $0.lowercased().contains(searchText.lowercased()) && !$0.contains("1") }
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
                
                Text("Manage Friends").font(.headline)
                
                Spacer()
            }.padding()
            
            
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search Friends", text: $searchText).padding(8).background(Color.orange.opacity(0.3)).cornerRadius(8).onChange(of: searchText) { filterFriends() }
            }.padding(.horizontal)
            

                VStack(alignment: .leading) {
                    Text("Online: ").font(.subheadline).padding(.leading)
                    ScrollView {
                        ForEach(onlineFriends, id: \.self) {friend in
                            FriendRow(friendName: friend, status: "Now Active")
                        }
                    }
                }.padding(.top)
                
            VStack(alignment: .leading) {
                Text("Offline: ").font(.subheadline).padding(.leading)
                ScrollView {
                    ForEach(offlineFriends, id: \.self) {friend in
                        FriendRow(friendName: friend, status: "Last Seen: 7 days")
                    }
                }
            }
            
            
            Spacer()
            
            
        }.background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    ManageFriendsView()
}
