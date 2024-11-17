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
    var profilePicURL: String
    
    //Testing purposes
    init(name: String, score: Double) {
        self.id = ""
        self.name = name
        self.score = score
        self.profilePicURL = "None"
    }
    
    //Full init
    init(id: String, name: String, score: Double, profilePicURL: String) {
        self.id = id
        self.name = name
        self.score = score
        self.profilePicURL = profilePicURL
    }
}

struct ChallengeView: View {
    var participants: [Person]
    var challenge: Challenge
    
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab: String = "Leaderboard"
    var tabs = ["Leaderboard", "Description"]
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    ForEach(tabs, id: \.self) { tab in
                        if (tab == selectedTab) {
                            Text(tab)
                                .font(.system(size: 17, weight: .medium))
                                .frame(width: UIScreen.main.bounds.size.width / 2, alignment: .center)
                                .overlay(VStack {
                                    Divider().frame(height: 2).background(Color.black).offset(x: 0, y: 20)
                                })
                        } else {
                            Button {
                                selectedTab = tab
                            } label: {
                                Text(tab)
                                    .foregroundStyle(.gray)
                                    .frame(width: UIScreen.main.bounds.size.width / 2, alignment: .center)
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
                
                if (selectedTab == "Description") {
                    VStack(alignment:.leading) {
                        Image("ChallengeDefault")
                            .resizable()
                            .frame(maxWidth: .infinity)
                            .scaledToFit()
                            .colorMultiply(.gray)
                            .cornerRadius(15)
                            .padding(.bottom, 20)

                        
                        HStack {                            
                            Text("Time Period: ")
                                .font(.system(size:20))
                                .bold()
                            
                            Text(Challenge.dateRange(start: challenge.dateCreated, end: challenge.endDate))
                                .font(.system(size:20))
                            
                        }
                        .padding(.bottom, 15)
                        
                        HStack {
                            Text("Activity: ")
                                .font(.system(size:20))
                                .bold()
                            Text(challenge.challengeType)
                                .font(.system(size:20))
                        }
                        .padding(.bottom, 15)
                        
                        HStack {
                            Text("Metric: ")
                                .font(.system(size:20))
                                .bold()
                            Text(challenge.dataMeasured)
                                .font(.system(size:20))
                        }
                            .padding(.bottom, 15)
                        
                        Divider()
                        
                        Text("Join Code")
                            .font(.system(size:20))
                            .bold()
                            .padding(.bottom, 10)
                        
                        HStack {
                            Spacer()
                            Text(challenge.accessCode)
                                    .font(.system(size:40))
                                    .bold()
                                    .padding(8)
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 2))
                            Spacer()
                        }
                        
                        Button(action: {
                            
                        }){
                            HStack {
                                Image(systemName: "arrowshape.backward.circle")
                                    .resizable()
                                    .frame(width:30, height: 30)
                                    .scaledToFit()
                                    .padding(.trailing, 10)
                                Text("Leave Challenge")
                                    .font(.system(size:30))
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(.gray)
                            .cornerRadius(15)
                            .padding(.vertical, 20)
                        }

                        
                    }
                    .padding(.horizontal, 15)
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
                        Text(Challenge.timeRemaining(endDate: challenge.endDate))
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
