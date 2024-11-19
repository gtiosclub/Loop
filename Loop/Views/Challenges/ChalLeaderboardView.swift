//
//  ChalLeaderboardView.swift
//  Loop
//
//  Created by Jason Wrzesien on 9/24/24.
//

import SwiftUI

struct ChalLeaderboardView: View {
    var personList: [Person]
    @ObservedObject var user = User.shared
    
    var body: some View {
        let sortedPersonList = personList.sorted(by: {$0.score > $1.score})
        let userRank = sortedPersonList.firstIndex(where: { $0.id == user.uid })
        
        PodiumView(personList: sortedPersonList)
            .padding(.vertical, -55)
    
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.lightGray))
                .frame(width: 375, height: 50)
            
            HStack {
                Text("You are currently rank")
                    .fontWeight(.light)
                
                Spacer()
                
                Text(String(format: "%.1f miles", sortedPersonList[userRank!].score))
                    .fontWeight(.medium)

                HStack {
                    Text("\(userRank! + 1)")
                    Image(systemName: "arrowtriangle.up.fill")
                        .font(.system(size: 9, weight: .regular))
                        .opacity(0.5)
                }
                .padding(.leading, 30)
                .fontWeight(.medium)
                
            }
            .font(.system(size: 14))
            .padding(.horizontal, 30)
        }
        .padding(.top, -30)
        
        VStack {
            if (sortedPersonList.count > 3) {
                ForEach(3..<sortedPersonList.count, id: \.self) { index in
                    HStack {
//                        
//                        Circle()
//                            .foregroundColor(.gray)
//                            .frame(width: 30, height: 30)
                        if (sortedPersonList[index].profilePicURL.isEmpty || sortedPersonList[index].profilePicURL == "None") {
                            Circle()
                                .foregroundColor(.gray)
                                .frame(width: 65, height: 65)
                                .padding(.leading, 15)
                        } else {
                            if let url = URL(string: sortedPersonList[index].profilePicURL) {
                                AsyncImage(url: url) { image in
                                    image.resizable().scaledToFill()
                                        .frame(width: 65, height: 65).clipShape(.circle)
                                        .padding(.leading, 15)
                                } placeholder: {
                                    Circle()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.gray)
                                        .padding()
                                        .overlay {
                                            ProgressView()
                                        }
                                }

                            }
                        }

                        
                        Text(sortedPersonList[index].name)
                            .fontWeight(.light)
                        
                        Spacer()
                        
                        Text(String(format: "%.1f miles", sortedPersonList[index].score))
                            .fontWeight(.medium)
                        
                            Text(String(index + 1))
                            Image(systemName: "arrowtriangle.up.fill")
                            .padding(.trailing, 20)
                        
                            
//                            HStack {
//                                Circle()
//                                    .foregroundColor(.gray)
//                                    .frame(width: 30, height: 30)
//                                
//                                Text(sortedPersonList[index].name)
//                                    .fontWeight(.light)
//                                
//                                Spacer()
//                                
//                                Text(String(format: "%.1f miles", sortedPersonList[index].score))
//                                    .fontWeight(.medium)
//                                
//                                HStack {
//                                    Text(String(index + 1))
//                                    Image(systemName: "arrowtriangle.up.fill")
//                                        .font(.system(size: 9, weight: .regular))
//                                        .opacity(0.5)
//                                }
//                                .padding(.leading, 30)
//                                .fontWeight(.medium)
//                                
//                            }
//                            .font(.system(size: 14))
//                            .padding(.horizontal, 30).padding(.vertical, 5)
                        }
                    Divider()
                    }
                }
            }
        }
    }

#Preview {
    ChalLeaderboardView(personList: [Person(name:"Ryan", score: 4.2), Person(name:"Max", score: 14.8), Person(name:"Jason", score: 7.1), Person(name:"Sam", score: 11.4), Person(name: "Joe", score: 5.5)])
}
