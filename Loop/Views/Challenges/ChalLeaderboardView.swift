//
//  ChalLeaderboardView.swift
//  Loop
//
//  Created by Jason Wrzesien on 9/24/24.
//

import SwiftUI

struct ChalLeaderboardView: View {
    var personList: [Person]
    var colorList: [Color] = [.yellow, .gray, .orange]
    
    
    
    var body: some View {
        HStack {
            Text("Leaderboard")
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(.orange)
                .padding([.leading, .trailing, .bottom], 15)
                .padding(.top, 30)
            Spacer()
        }
        
        let sortedPersonList = personList.sorted(by: {$0.distance > $1.distance})
        let maxProgressLength: Double = sortedPersonList[0].distance
        
        ForEach(0..<sortedPersonList.count, id: \.self) { index in
            HStack {
                ZStack {
                    Circle()
                        .foregroundColor(colorList[index])
                        .frame(width: 50, height: 50)
                    Text(String(index + 1))
                        .font(.system(size: 25, weight: .semibold))
                        .foregroundColor(.black)
                }
                
                VStack {
                    HStack {
                        Text(sortedPersonList[index].name)
                            .font(.system(size: 20, weight: .bold))
                        Spacer()
                        Text(String(sortedPersonList[index].distance) + " mi")
                            .font(.system(size: 14, weight: .bold))
                            .padding(.trailing, 10)
                    }
                    .padding(.top, -5)
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(colorList[index])
                            .frame(width: 295*(sortedPersonList[index].distance/maxProgressLength), height: 5)
                            .padding(.top, -10)
                        Spacer()
                    }
                }
            }
            .padding([.leading, .trailing], 15)
        }
    }
}

#Preview {
    ChalLeaderboardView(personList: [Person(name:"Ryan", distance: 50.2), Person(name:"Max", distance: 104.8), Person(name:"Jason", distance: 85)])
}
