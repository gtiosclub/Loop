//
//  SelfProfileView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI
import FirebaseAuth

struct SelfProfileView: View {
    @State var user = User(uid: "String", name: "String", username: "String", challengeIds: ["String"], profilePictureId: "String", friends: ["String"], incomingRequest: ["String"])
    var userId: String
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var name: String = "name"
    @State private var profile_image : String = ""
    @State private var location: String = "Atlanta, GA"
    @State private var createdDate: String = "Oct 2024"
    @State private var friend_count: Int = 0
    @State private var selectedTab = 0
    @State private var incomingRequests : [String] = []
    
    init (userId: String) {
        self.userId = userId
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(width: 20)
                Circle()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text(location)
                            .padding(3)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                        
                        Spacer().frame(width: 18)
                        
                        Text(createdDate)
                            .padding(3)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                    }
                    .font(.subheadline)
                }
                
                Spacer()
                VStack {
                    NavigationLink(destination: SettingsView()) {
                        VStack(spacing: 5) {
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(.black)
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(.black)
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(.black)
                        }
                        .frame(width: 30)
                        .padding(.trailing, 20)
                    }
                }
                .padding(.bottom, 20)
            }
            HStack {
                Spacer().frame(width: 20)
                NavigationLink(destination: ManageFriendsView(profileViewModel: profileViewModel, userId: userId)) {
                    VStack(alignment: .leading) {
                        Text("Friends")
                            .font(.subheadline)
                        
                        Text("\(friend_count)")
                            .fontWeight(.bold)
                    }
                }.foregroundStyle(.black)
                
                Spacer()
                NavigationLink(destination: AddFriendsView(profileViewModel: profileViewModel, requestingFriends: incomingRequests, userId: userId, user: user)){
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)))
                            .frame(width: 35, height: 35)
                            .cornerRadius(10)
                        Image(systemName: "person.badge.plus")
                            .foregroundStyle(.black)
                    }
                }
            }.padding([.leading, .trailing])
            
            HStack {
                Spacer()
                
                Button(action: {
                    selectedTab = 0
                }) {
                    Text("Activity")
                        .foregroundColor(selectedTab == 0 ? .black : .gray)
                }
                
                Spacer()
                
                Button(action: {
                    selectedTab = 1
                }) {
                    Text("Stats")
                        .foregroundColor(selectedTab == 1 ? .black : .gray)
                }
                
                Spacer()
                
                Button(action: {
                    selectedTab = 2
                }) {
                    Text("Trophies")
                        .foregroundColor(selectedTab == 2 ? .black : .gray)
                }
                
                Spacer()
                
            }
            .font(.headline)            
            VStack(spacing: 0) {
                Divider()
                
                ScrollView {
                    if selectedTab == 0 {
                        SelfProfileActivityView()
                    } else if selectedTab == 1 {
                        SelfProfileStatsView()
                    } else {
                        TrophyView()
                    }
                }
            }
            
            Spacer()
            
        }.onAppear {
            profileViewModel.fetchAllUsersExcludingFriends(for: userId)
            Task {
                friend_count = await profileViewModel.fetchFriendInfo(userId: userId)?.count ?? 0
                var user = await profileViewModel.getUserInfo(userId: userId)
                self.name = user?.name ?? "name"
                self.incomingRequests = user?.incomingRequest.map(\.self) ?? []
                self.user = user ?? User(uid: "String", name: "String", username: "String", challengeIds: ["String"], profilePictureId: "String", friends: ["String"], incomingRequest: ["String"])
                self.profile_image = user?.profilePictureId ?? ""
            }
        }
    }
}

#Preview {
    
}
