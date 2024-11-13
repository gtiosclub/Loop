//
//  ChallengeListView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct ChallengeListView: View {
    let challenges: [Challenge]
    @State private var selectedTab: String = "Active Challenges"
    var tabs = ["Active Challenges", "Past Challenges"]
    
    var body: some View {
        NavigationStack {
            HStack {
                Text("Challenges")
                    .font(.system(size: 26, weight: .medium))
                    .padding(.leading, 15)
                
                Spacer()
                
                NavigationLink {
                    CreateChallengeView()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 21))
                }
                .padding(.trailing, 16)
            }
            
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
            .padding(.top, 1).padding(.bottom, 10)
            
            ScrollView {
                ForEach(challenges, id: \.id) { challenge in
                    CardView(challenge: challenge)
                        .padding(.bottom, 5)
                }
            }
            .scrollIndicators(.hidden)
            .padding(.top, 10).padding(.horizontal, 10)
        }
        .foregroundColor(.black)
    }
}

#Preview {
    ChallengeListView(challenges: Challenge.sampleData)
}
