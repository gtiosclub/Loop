//
//  FriendProfileView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct FriendProfileView: View {
    @State public var wins: Int = 0
    @State public var lastActivity: String = "No recent activity"
    @State public var username: String
    @State public var name: String
    @State public var friends: Int = 12
    @State public var challenges: Int = 132
    @State public var description: String = "Im a friend"
    @State public var activities: [[String]] = [["Running", "Super Run", "1"], ["Jogging", "Slow Jog", "9"], ["Sitting", "Super Sit", "1"], ["Sleep", "Super Sleep", "100"]]
    var body: some View {
        VStack(spacing: -30) {
            HStack {
                Text(name)
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.leading, 10)
                Spacer()
            }
            .padding(.top, 60)
            .padding(.bottom, 10)
            
            HStack(spacing: 30) {
                ZStack {
                    Circle()
                        .frame(width: 85, height: 85)
                        .padding()
                        .foregroundColor(.black)
                }
                .padding()
                VStack {
                    NavigationLink(destination: ManageFriendsView()) {
                        VStack {
                            Text(String(friends))
                                .font(.system(size:14))
                                .bold()
                            Text("Friends")
                                .font(.system(size:13))
                        }
                    }.foregroundStyle(.black)
                }
                VStack {
                    Text(String(wins))
                        .font(.system(size:14))
                        .bold()
                    Text("Wins")
                        .font(.system(size:13))
                }.foregroundStyle(.black)
                VStack {
                    Text(String(challenges))
                        .font(.system(size:14))
                        .bold()
                    Text("Challenges")
                        .font(.system(size:13))
                }.foregroundStyle(.black)
            }
            .padding(.bottom, 10)
            .offset(x:-10, y:0)
            HStack {
                Text(username)
                    .bold()
                    .font(.system(size: 14))
                    .offset(x:-130, y:0)
            }
            .padding(.bottom, 40)
            Text(description)
                .frame(width: 362, height: 53)
                .font(.system(size: 13))
                .padding(.bottom, 40)
            Text(name+"'s Recent Activity")
                .padding(.bottom, 40)
            Rectangle()
                .frame(width: UIScreen.main.bounds.size.width, height: 1)
                .padding(.bottom, 13)
            VStack(alignment: .leading, spacing: 20) {
                ScrollView {
                    ForEach(activities, id: \.self) {activity in
                        PastActivity(name: name, type: activity[0], activityName: activity[1], placement: activity[2])
                    }
                }
            }
            .padding(20)
            .cornerRadius(15)
            .shadow(radius: 5)
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
   // FriendProfileView()
}
