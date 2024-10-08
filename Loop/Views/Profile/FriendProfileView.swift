//
//  FriendProfileView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct FriendProfileView: View {
    @State private var name: String = "My Name"
    @State private var username: String = "username"
    @State private var friendCount: Int = 0
    @State private var winCount: Int = 0
    @State private var challengesCount: Int = 0
    var body: some View {
        VStack {

            HStack {
                Text(name)
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()

                Button(action: {

                }) {
                    Text("Remove Friend")
                        .font(.subheadline)
                        .foregroundColor(.red)
                        .padding(6)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 1)
                        )
                    }
                }
            }

            .padding(.horizontal)
            .padding(.top, 8)

            HStack {
                VStack(alignment: .leading) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray)

                    Text(username)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.leading)

                Spacer()


                HStack(spacing: 30) {
                    VStack {
                        Text(String(friendCount))
                            .font(.headline)
                        Text("Friends")
                            .font(.caption)
                    }

                    VStack {
                        Text(String(winCount))
                            .font(.headline)
                        Text("Wins")
                            .font(.caption)
                    }

                    VStack {
                        Text(String(challengesCount))
                            .font(.headline)
                        Text("Challenges")
                            .font(.caption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                }
                .padding(.trailing)
            }
            .padding(.horizontal)
            .padding(.vertical)

            Divider()
                .padding(.vertical)

            Text( name + "'s" + " Recent Activity")
                .font(.headline)
                .padding(.bottom, 8)


            ScrollView(.vertical) {
                VStack(spacing: 10) {
                    ActivityCardView(name: name)
                    ActivityCardView(name: name)
                    ActivityCardView(name: name)
                    ActivityCardView(name: name)
                    ActivityCardView(name: name)
                }
                .padding(.horizontal)
            }
            .frame(maxHeight: .infinity)

            Spacer()
        }
        .padding(.bottom)
    }
}

struct ActivityCardView: View {
    @State var name: String
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

                Text("Physical Activity")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)

            Text("Competition Name")
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

struct FriendProfileView_Previews: PreviewProvider {
    static var previews: some View {
        FriendProfileView()
            .previewLayout(.fixed(width: 375, height: 800))
    }
}
