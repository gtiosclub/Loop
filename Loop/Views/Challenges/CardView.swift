//
//  CardView.swift
//  Loop
//
//  Created by joey on 9/23/24.
//

import SwiftUI

struct CardView: View {
    let challenge: Challenge
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ZStack {
                    Color(.lightGray)
                    
                    VStack {
                        HStack {
                            Text(challenge.title)
                                .font(.system(size: 26))
                                .padding([.leading, .top], 15).padding(.bottom, 0.5)
                            Spacer()
                        }
                        
                        HStack {
                            Label("04d 02h 44m", systemImage: "clock")
                                .padding(.leading, 15)
                            Spacer()
                        }
                        
                        Spacer()
                    }
                }
                .foregroundStyle(.white)
                .frame(height: 230)
                .clipShape(.rect(topLeadingRadius: 15, topTrailingRadius: 15))
                
                
                ZStack {
                    Color(.lightGray).brightness(0.15)
                    
                    VStack {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color(.lightGray))
                                    .frame(width: 30, height: 30)
                                Circle()
                                    .stroke(Color(.lightGray), lineWidth: 0)
                                    .fill(Color(.lightGray))
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 45)
                                Circle()
                                    .stroke(Color(.lightGray), lineWidth: 0)
                                    .fill(Color(.lightGray))
                                    .frame(width: 30, height: 30)
                                    .padding(.leading, 90)
                            }
                            .padding(.leading, -30)
                            
                            Text(String(challenge.attendees.count) + " Participants")
                            
                            Spacer()
                            
                            Label("Oct 10 - Nov 1", systemImage: "calendar")
                                .padding(.trailing, 20)
                        }
                        
                        NavigationLink {
                            ChallengeView(challenge: challenge)
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(.lightGray))
                                    .frame(width: 350, height: 40)
                                
                                Text("View Challenge")
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                        .foregroundStyle(.black)
                    }
                }
                .frame(height: 100)
                .clipShape(.rect(bottomLeadingRadius: 15, bottomTrailingRadius: 15))
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var challenge = Challenge.sampleData[0]
    static var previews: some View {
        CardView(challenge: challenge)
            .previewLayout(.fixed(width: 400, height: 60))
    }
}
