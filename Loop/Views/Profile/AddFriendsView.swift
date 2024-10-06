//
//  AddFriendsView.swift
//  Loop
//
//  Created by Jihoon Kim on 10/3/24.
//

import SwiftUI

struct AddFriendRow: View {
    var friendName: String
    var status: String
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill").font(.system(size: 40)).foregroundColor(.gray)
            VStack(alignment: .leading) {
                Text(friendName).font(.headline)
                Text(status).font(.caption).foregroundColor(.gray)
            }
            Spacer()
            VStack {
                Button(action: {
                    print("friend added")
                }) {Image(systemName: "plus")
                        .font(.system(size: 24))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }.padding().background(Color.white).cornerRadius(10).shadow(radius: 2).padding(.horizontal)
    }
}
struct AcceptFriendRow: View {
    var friendName: String
    var status: String
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill").font(.system(size: 40)).foregroundColor(.gray)
            VStack(alignment: .leading) {
                Text(friendName).font(.headline)
                Text(status).font(.caption).foregroundColor(.gray)
            }
            Spacer()
            VStack {
                Button(action: {
                    print("friend added")
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
                }) {Image(systemName: "xmark")
                        .font(.system(size: 24))
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
        }.padding().background(Color.white).cornerRadius(10).shadow(radius: 2).padding(.horizontal)
    }
}

struct AddFriendsView: View {
    @State private var searchText: String = ""
    @State private var allFriends: [String] = ["Kevin", "Ethan", "Jason"]
    @State private var requestingFriends: [String] = ["Me", "Kevin", "Ethan", "Jason"]
    @State private var matchedFriends: [String] = []
    @Environment(\.presentationMode) var presentationMode
    
    private func filterFriends() {
        if searchText.isEmpty {
            // When search is empty, reset to the original friends list
            matchedFriends = []
        } else {
            // Filter friends by search text
            matchedFriends = allFriends.filter { $0.lowercased().contains(searchText.lowercased()) && !$0.contains("1") }
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
            }.padding()
            
            
            HStack {
                Image(systemName: "magnifyingglass").foregroundColor(.gray)
                TextField("Search Friends", text: $searchText).padding(8).background(Color.orange.opacity(0.3)).cornerRadius(8).onChange(of: searchText) { filterFriends() }
            }.padding(.horizontal)
            
            VStack(alignment: .leading) {
                ScrollView {
                    ForEach(matchedFriends, id: \.self) {friend in
                        AddFriendRow(friendName: friend, status: "Now Active")
                    }
                }
            }.padding(.top)
            VStack(alignment: .leading) {
                Text("Incoming Requests: ").font(.subheadline).padding(.leading)
                ScrollView {
                    ForEach(requestingFriends, id: \.self) {friend in
                        AcceptFriendRow(friendName: friend, status: "Last Seen: 7 days")
                    }
                }
            }
            
                
            
            
        }.background(Color.gray.opacity(0.1).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
            .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    AddFriendsView()
}
