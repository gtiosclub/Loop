//
//  ManageFriendsView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct ManageFriendsView: View {
    @State private var searchText: String = ""
    @State private var friends: [String] = ["friend 1", "friend 2", "friend 3"]
    @State private var allFriends: [String] = ["friend 1", "friend 2", "friend 3", "friend 4", "friend 5", "friend 6"]
    @State private var filteredFriends: [String] = []
    
    var body: some View {
        Text("Manage Friends View")
    }
}

#Preview {
    ManageFriendsView()
}
