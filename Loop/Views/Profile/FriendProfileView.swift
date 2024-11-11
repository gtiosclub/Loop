//
//  FriendProfileView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct FriendProfileView: View {
    @State var name: String
    @State private var location: String = "Atlanta, GA"
    @State private var createdDate: String = "Oct 2024"
    @State private var following: Int = 30
    @State private var followers: Int = 30
    @State private var selectedTab = 0
    
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
            }
            HStack {
                Spacer().frame(width: 20)

                VStack(alignment: .leading) {
                    Text("Following")
                        .font(.subheadline)
                    
                    Text("\(following)")
                        .fontWeight(.bold)
                }
                
                Spacer().frame(width: 40)
                NavigationLink(destination: ManageFriendsView()) {
                    VStack(alignment: .leading) {
                        Text("Followers")
                            .font(.subheadline)
                        
                        Text("\(followers)")
                            .fontWeight(.bold)
                    }
                }.foregroundStyle(.black)
                
                Spacer()
                
            }.padding([.leading, .trailing])
            
            HStack {

                
                Spacer()
                
                ForEach(0..<4) { _ in
                    
                    Spacer().frame(width: 5)
                    
                    Image("profile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 120)
                    
                    Spacer().frame(width: 5)
                    
                }.padding(.bottom)
                
                Spacer()
                
            }
            
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
                .padding(.trailing)
            }
            
            Spacer()
            
        }
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
        FriendProfileView(name: "name")
            .previewLayout(.fixed(width: 375, height: 800))
    }
}

