//
//  SelfProfileView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct PastActivity: View {
    var name: String
    var type: String
    var activityName: String
    var placement: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.gray)

                Text(name)
                    .font(.subheadline)

                Spacer()

                Text(type)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)

            Text(activityName)
                .font(.headline)
                .padding(.horizontal)

            HStack {
                Image(systemName: "chart.bar.fill")
                    .resizable()
                    .frame(width: 80, height: 40)
                    .padding(.horizontal)

                Text( name + " Placed 1st!")
                    .font(.headline)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Spacer()
            }
            .padding(.horizontal)

            HStack {
                Text("Today at 9:16 PM")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.horizontal)

                Spacer()

                Image(systemName: "eye.slash.fill")
                    .padding(.horizontal)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}

struct SelfProfileView: View {
    @State private var wins: Int = 0
    @State private var lastActivity: String = "No recent activity"
    @State private var username: String = "@john_running"
    @State private var name: String = "John"
    @State private var friends: Int = 12
    @State private var challenges: Int = 132
    @State private var activities: [[String]] = [["Running", "Super Run", "1"], ["Jogging", "Slow Jog", "9"], ["Skipping", "Skip Challenge", "1"], ["Running", "My Running", "100"]]
    var body: some View {
        VStack(spacing: -30) {
            HStack {
                Spacer()
                
                VStack {
                    NavigationLink(destination: SettingsView()) {
                    }
                    .frame(width: 30)
                    .padding(.trailing, 20)
                }
            }
            .padding(.trailing, 20)
        .padding(.top, 60)
        .padding(.bottom, 10)
        
            HStack(spacing: 30) {
            ZStack {
                Circle()
                    .frame(width: 85, height: 85)
                    .padding()
                    .foregroundColor(.gray)
            }
            .padding()
            VStack {
                NavigationLink(destination: ManageFriendsView()) {
                    VStack {
                        Text(String(friends))
                            .font(.system(size:14))
                            .bold()
                        Text("Following")
                            .font(.system(size:13))
                    }
                }.foregroundStyle(.black)
            }
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
        HStack {
            NavigationLink(destination: EditProfileView()) {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)))
                        .frame(width: 124, height: 33)
                        .cornerRadius(10)
                    Text("Edit Profile")
                        .font(.system(size: 13))
                        .foregroundStyle(.black)
                        .bold()
                    
                }
            }
            Button(action: {
                //implement
            }) {
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)))
                        .frame(width: 124, height: 33)
                        .cornerRadius(10)
                    Text("Share Profile")
                        .font(.system(size: 13))
                        .foregroundStyle(.black)
                        .bold()
                    
                }
            }
            NavigationLink(destination: AddFriendsView()){
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)))
                        .frame(width: 35, height: 35)
                        .cornerRadius(10)
                    Image(systemName: "person.badge.plus")
                        .foregroundStyle(.black)
                }
            }
        }
        .padding(.bottom, 45)
        Text(name+"'s Recent Activity")
            .padding(.bottom, 40)
        VStack(alignment: .leading, spacing: 20) {
            ScrollView {
                ForEach(activities, id: \.self) {activity in
                    PastActivity(name: name, type: activity[0], activityName: activity[1], placement: activity[2])
                }
            }
        }
        .padding(10)
        .cornerRadius(15)
        .shadow(radius: 5)
        
        Spacer()
    }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
    
    private func statusColor(for wins: Int) -> Color {
        switch wins {
        case 0..<100:
            return Color.brown
        case 100..<200:
            return Color.gray
        case 200...:
            return Color.yellow
        default:
            return Color.clear
        }
    }
}

#Preview {
    SelfProfileView()
}
