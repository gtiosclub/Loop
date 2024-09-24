//
//  ChallengeView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct ChallengeView: View {
    @Environment(\.dismiss) private var dismiss
    var colorList: [Color] = [.yellow, .gray, .orange]
    
    var body: some View {
        ZStack {
            Color.black
                .brightness(0.2)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Challenge Title")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(.red)
                        .padding([.leading, .trailing], 15)
                        .padding([.top, .bottom], 2)
                    Spacer()
                }
                
                HStack {
                    Text("Most Miles Ran")
                    Spacer()
                    Text("6/1 - 9/1")
                }
                .padding([.leading, .trailing], 15)
                .font(.system(size: 20, weight: .bold))
                
                HStack {
                    Text("Leaderboard")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(.orange)
                        .padding([.leading, .trailing, .bottom], 15)
                        .padding(.top, 30)
                    Spacer()
                }
                
                ForEach(1..<4, id: \.self) { index in
                    HStack {
                        ZStack {
                            Circle()
                                .foregroundColor(colorList[index - 1])
                                .frame(width: 50, height: 50)
                            Text(String(index))
                                .font(.system(size: 25, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        
                        VStack {
                            HStack {
                                Text("Name" + String(index))
                                    .font(.system(size: 20, weight: .bold))
                                Spacer()
                                Text("200 mi")
                                    .font(.system(size: 14, weight: .bold))
                            }
                            .padding(.top, -5)
                            
                            RoundedRectangle(cornerRadius: 15)
                                    .fill(colorList[index - 1])
                                    .frame(width: .infinity, height: 5)
                                    .padding(.top, -10)
                        }
                    }
                    .padding([.leading, .trailing], 15)
                }
                
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
    ChallengeView()
}
