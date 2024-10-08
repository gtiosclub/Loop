//
//  FeedView.swift
//  Loop
//
//  Created by Victor Andrade on 10/1/24.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(0..<6) { index in
                        if index % 3 == 0 {
                            WorkoutCardView(
                                name: "Jane Doe",
                                avatar: "avatar1",
                                miles: "3.5",
                                pace: "10:45",
                                time: "34:56",
                                date: "Today at 9:16 PM"
                            )
                            .padding(.horizontal)
                        } else if index % 3 == 1 {
                            CompetitionCardView(
                                name: "John Smith",
                                avatar: "avatar2",
                                competition: "Marathon Challenge",
                                result: "John Placed 2nd!",
                                date: "Yesterday at 6:45 PM"
                            )
                            .padding(.horizontal)
                        } else {
                            WorkoutCardView(
                                name: "Emily Brown",
                                avatar: "avatar3",
                                miles: "5.2",
                                pace: "9:30",
                                time: "45:20",
                                date: "Today at 7:30 AM"
                            )
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Home Feed")
        }
    }
}

struct WorkoutCardView: View {
    var name: String
    var avatar: String
    var miles: String
    var pace: String
    var time: String
    var date: String

    @State private var isLiked = false

    var body: some View {
        NavigationLink(destination: DetailedStatsView(name: name)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(avatar)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                        .shadow(radius: 5)
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.headline)
                        Text("Completed a workout")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                
                HStack(spacing: 20) {
                    StatItem(title: "Miles", value: miles)
                    StatItem(title: "Pace", value: pace)
                    StatItem(title: "Time", value: time)
                }

                HStack {
                    Button(action: {
                        withAnimation {
                            isLiked.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? .red : .gray)
                            Text("Like")
                                .foregroundColor(.primary)
                        }
                    }
                    Spacer()
                    Button(action: {
    
                    }) {
                        HStack {
                            Image(systemName: "message")
                            Text("Comment")
                        }
                        .foregroundColor(.primary)
                    }
                }
                .padding(.top, 8)


                Text(date)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.white, Color(.systemGray6)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .shadow(radius: 5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CompetitionCardView: View {
    var name: String
    var avatar: String
    var competition: String
    var result: String
    var date: String

    @State private var isLiked = false

    var body: some View {
        NavigationLink(destination: DetailedStatsView(name: name)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(avatar)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 50, height: 50)
                        .shadow(radius: 5)
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.headline)
                        Text("Participated in a competition")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                
                Text(competition)
                    .font(.title2)
                    .fontWeight(.bold)
                Text(result)
                    .font(.subheadline)
                    .foregroundColor(.secondary)


                HStack {
                    Button(action: {
                        withAnimation {
                            isLiked.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(isLiked ? .red : .gray)
                            Text("Like")
                                .foregroundColor(.primary)
                        }
                    }
                    Spacer()
                    Button(action: {

                    }) {
                        HStack {
                            Image(systemName: "message")
                            Text("Comment")
                        }
                        .foregroundColor(.primary)
                    }
                }
                .padding(.top, 8)

      
                Text(date)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [.white, Color(.systemGray6)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .shadow(radius: 5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct StatItem: View {
    var title: String
    var value: String

    var body: some View {
        VStack {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
