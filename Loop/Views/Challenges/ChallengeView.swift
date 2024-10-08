//
//  ChallengeView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

class Person {
    var name: String
    var distance: Double
    
    init(name: String, distance: Double) {
        self.name = name
        self.distance = distance
    }
}

struct ChallengeView: View {
    var challenge: Challenge
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black
                .brightness(0.2)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text(challenge.title)
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(.red)
                        .padding([.leading, .trailing], 15)
                        .padding([.top, .bottom], 2)
                    Spacer()
                }
                
                HStack {
                    Text(challenge.challengeType)
                    Spacer()
                    Text("\(challenge.dateCreated.formatted(.dateTime.day().month(.twoDigits))) - \(challenge.endDate.formatted(.dateTime.day().month(.twoDigits)))")
                    
                }
                .padding([.leading, .trailing], 15)
                .font(.system(size: 20, weight: .bold))
                
                ChalLeaderboardView(personList: [Person(name:"Ryan", distance: 50.2), Person(name:"Max", distance: 104.8), Person(name:"Jason", distance: 85), Person(name:"Sam", distance: 90.6)])
                
                HStack {
                    Text("Activities")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.blue)
                        .padding([.leading, .trailing, .bottom], 15)
                        .padding(.top, 20)
                    Spacer()
                }
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .font(.system(size: 15, weight: .bold))
                            Text("All Challenges")
                                .font(.system(size: 20))
                                .padding(.leading, -5)
                        }
                    }
                }
            }
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    ChallengeView(challenge: Challenge.sampleData[0])
}
