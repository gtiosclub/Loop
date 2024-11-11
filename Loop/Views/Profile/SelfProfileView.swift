//
//  SelfProfileView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct SelfProfileView: View {
    @State private var name: String = "Jane Doe"
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
                            .background(Color.red)
                            .foregroundColor(Color.white)
                            .cornerRadius(4)
                        
                        Spacer().frame(width: 18)
                        
                        Text(createdDate)
                            .padding(3)
                            .background(Color.red)
                            .foregroundColor(Color.white)
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
                NavigationLink(destination: AddFriendsView()){
                    ZStack {
                        Rectangle()
                            .foregroundColor(.red)
                            .frame(width: 35, height: 35)
                            .cornerRadius(10)
                        Image(systemName: "person.badge.plus")
                            .foregroundStyle(.white)
                    }
                }
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
            }
            
            Spacer()
            
        }
    }
}

#Preview {
    SelfProfileView()
}
