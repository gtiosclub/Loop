//
//  ChallengeCode.swift
//  Loop
//
//  Created by Jason Wrzesien on 11/12/24.
//

import SwiftUI

struct ChallengeCode: View {
    let challengeCode: String = "ABCDE"
    let challenge: Challenge
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Challenge")
                    .font(.system(size: 60, weight: .medium))
                    .padding(.top, 60)
                Text("created!")
                    .font(.system(size: 60, weight: .medium))
                    .padding(.bottom, 20)
                
                Text("Use the following code to invite")
                    .font(.system(size: 20, weight: .light))
                    .opacity(0.5)
                Text("people to your challenge")
                    .font(.system(size: 20, weight: .light))
                    .opacity(0.5)
                    .padding(.bottom, 100)
                
                
                Text(challengeCode)
                    .font(.system(size: 60, weight: .medium))
                    .frame(width: 335, height: 104)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(.lightGray), lineWidth: 5)
                    )
                    .padding(.bottom, 20)
                
                Button {
                    UIPasteboard.general.string = challengeCode
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .frame(width: 141, height: 46)
                            .foregroundColor(Color(.lightGray))
                        
                        Text("Copy")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                }
                
                Spacer()
                
                NavigationLink {
                    ChallengeView(challenge: challenge)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .frame(width: 350, height: 51)
                            .foregroundColor(Color(.lightGray))
                        
                        Text("Done")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

#Preview {
    ChallengeListView(challenges: Challenge.sampleData)
}
