//
//  ChallengeView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

class Person {
    var id: String
    var name: String
    var score: Double
    
    //Testing purposes
    init(name: String, score: Double) {
        self.id = ""
        self.name = name
        self.score = score
    }
    
    //Full init
    init(id: String, name: String, score: Double) {
        self.id = id
        self.name = name
        self.score = score
    }
}

struct ChallengeView: View {
    var participants: [Person]
    var challenge: Challenge
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: String = "Leaderboard"
    var tabs = ["Leaderboard", "Statistics", "Description"]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    ForEach(tabs, id: \.self) { tab in
                        if (tab == selectedTab) {
                            Text(tab)
                                .font(.system(size: 17, weight: .medium))
                                .frame(width: UIScreen.main.bounds.size.width / 3, alignment: .center)
                                .overlay(VStack {
                                    Divider().frame(height: 2).background(Color.black).offset(x: 0, y: 20)
                                })
                        } else {
                            Button {
                                selectedTab = tab
                            } label: {
                                Text(tab)
                                    .foregroundStyle(.gray)
                                    .frame(width: UIScreen.main.bounds.size.width / 3, alignment: .center)
                                    .overlay(VStack {
                                        Divider().frame(height: 2).background(Color.gray).opacity(0.5).offset(x: 0, y: 20)
                                    })
                            }
                        }
                    }
                    .padding(.horizontal, -4)
                }
                .padding(.top, 15).padding(.bottom, 20)
                
                if (selectedTab == "Leaderboard") {
                    ChalLeaderboardView(personList: participants)
                }
                
                if (selectedTab == "Statistics") {
                    //stats view
                }
                
                if (selectedTab == "Description") {
                    //description view
                }
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 12, weight: .semibold))
                            Text(challenge.title)
                                .font(.system(size: 21, weight: .semibold))
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                        Text("04d 02h 44m")
                            .font(.system(size: 15))
                            .padding(.leading, -5)
                    }
                    .padding(.top, 2)
                }
            }
            .foregroundStyle(.black)
        }
        .foregroundStyle(.white)
        .toolbar(.hidden, for: .tabBar)
    }
}

#Preview {
    ChallengeListView()
}
