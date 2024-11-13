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
                    Image("ChallengeDefault")
                        .resizable()
                        .scaledToFill()
                        .colorMultiply(.gray)
                    VStack {
                        HStack {
                            Text(challenge.title)
                                .font(.system(size: 26))
                                .padding([.leading, .top], 15).padding(.bottom, 0.5)
                                .bold()
                            Spacer()
                        }
                        
                        HStack {
                            Label(Challenge.timeRemaining(endDate: challenge.endDate), systemImage: "clock")
                                .padding(.leading, 15)
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            
                        }
                    }
                }
                .foregroundStyle(.white)
                .frame(height: 230)
                .clipShape(.rect(topLeadingRadius: 15, topTrailingRadius: 15))
                
                
                ZStack {
                    Color(.lightGray).brightness(0.15)
                    
                    VStack {
                        HStack {
                            Image(systemName: "person.fill")
                            .padding(.leading, 20)
                            
                            Text(String(challenge.attendees.count) + " Participants")
                            
                            Spacer()
                            
                            Label(Challenge.dateRange(start:challenge.dateCreated, end: challenge.endDate), systemImage: "calendar")
                                .padding(.trailing, 20)
                        }
                        
                        NavigationLink {
                            ChallengeView(participants: challenge.attendeesFull, challenge: challenge)
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(red: 232/255,green: 78/255, blue: 78/255))
                                    .frame(width: 350, height: 40)
                                
                                Text("View Challenge")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
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
