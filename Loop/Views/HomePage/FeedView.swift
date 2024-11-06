//
//  FeedView.swift
//  Loop
//
//  Created by Victor Andrade on 10/1/24.
//

import SwiftUI
import WatchConnectivity

struct FeedView: View {

    @StateObject private var viewModel = FeedViewModel()
    let userId: String


    var body: some View {
        NavigationView {
            ScrollView {

                VStack(spacing: 16) {
                    ForEach(viewModel.friendPosts, id: \.id) { post in
                        TextCardView(
                            name: post.name,
                            avatar: post.avatar,
                            post: post.content,
                            date: post.date
                        )
                        .padding(.horizontal)
                    }
                    .padding(.top)
                }   
                .navigationTitle("Home Feed")                     
            }
            .navigationTitle("Home Feed")
            .onAppear {
                viewModel.fetchFriendPosts(for: userId)
            }
        }
    }
}

struct TextCardView: View {
    var name: String
    var avatar: String
    var post: String
    var date: String

    @State private var isLiked = false

    var body: some View {
        NavigationLink(destination: DetailedStatsView(name: name)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: avatar)
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 25, height: 25)
                        .shadow(radius: 5)
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.headline)
                        Text("Shared a post")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                }
                
                Text(post)
                    .font(.body)
                    .foregroundColor(.primary)

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

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView(userId: "currentLoggedInUserId")
    }
}
