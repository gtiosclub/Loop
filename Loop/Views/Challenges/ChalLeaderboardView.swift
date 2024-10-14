//
//  ChalLeaderboardView.swift
//  Loop
//
//  Created by Jason Wrzesien on 9/24/24.
//

import SwiftUI

struct ChalLeaderboardView: View {
    var personList: [Person]
    
    var body: some View {
        let sortedPersonList = personList.sorted(by: {$0.distance > $1.distance})
        
        HStack {
            if (sortedPersonList.count > 2) {
                VStack {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 65, height: 65)
                    
                    Text(sortedPersonList[2].name)
                        .font(.system(size: 16, weight: .light))
                        .padding(.bottom, -1)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .fill(Color(.lightGray))
                            .frame(width: 90, height: 25)
                        
                        Text(String(sortedPersonList[2].distance) + " miles")
                            .font(.system(size: 12, weight: .light))
                    }
                    .padding(.bottom, -5)
                    
                    ZStack {
                        Rectangle()
                            .stroke(Color.black, style: StrokeStyle(lineWidth: 3))
                            .frame(width: 125, height: 160*(sortedPersonList[2].distance/sortedPersonList[0].distance))
                            .offset(x: 0, y: -4)
                        
                        Rectangle()
                            .frame(width: 122, height: 165*(sortedPersonList[2].distance/sortedPersonList[0].distance))
                            .foregroundStyle(.white)
                        
                        Text("3")
                            .font(.system(size: 65, weight: .light))
                    }
                }
                .offset(x: 8, y: 25*(sortedPersonList[0].distance/sortedPersonList[2].distance))
            }
            
            VStack {
                Circle()
                    .foregroundColor(.gray)
                    .frame(width: 90, height: 90)
                
                Text(sortedPersonList[0].name)
                    .font(.system(size: 16, weight: .light))
                    .padding(.bottom, -1)
                
                ZStack {
                    RoundedRectangle(cornerRadius: 7)
                        .fill(Color(.lightGray))
                        .frame(width: 90, height: 25)
                    
                    Text(String(sortedPersonList[0].distance) + " miles")
                        .font(.system(size: 12, weight: .light))
                }
                .padding(.bottom, -5)
                
                ZStack {
                    Rectangle()
                        .stroke(Color.black, style: StrokeStyle(lineWidth: 3))
                        .frame(width: 125, height: 160)
                        .offset(x: 0, y: -4)
                    
                    Rectangle()
                        .frame(width: 122, height: 165)
                        .foregroundStyle(.white)
                    
                    Text("1")
                        .font(.system(size: 75, weight: .medium))
                }
            }
            
            if (sortedPersonList.count > 1) {
                VStack {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 65, height: 65)
                    
                    Text(sortedPersonList[1].name)
                        .font(.system(size: 16, weight: .light))
                        .padding(.bottom, -1)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .fill(Color(.lightGray))
                            .frame(width: 90, height: 25)
                        
                        Text(String(sortedPersonList[1].distance) + " miles")
                            .font(.system(size: 12, weight: .light))
                    }
                    .padding(.bottom, -5)
                    
                    ZStack {
                        Rectangle()
                            .stroke(Color.black, style: StrokeStyle(lineWidth: 3))
                            .frame(width: 125, height: 160*(sortedPersonList[1].distance/sortedPersonList[0].distance))
                            .offset(x: 0, y: -4)
                        
                        Rectangle()
                            .frame(width: 122, height: 165*(sortedPersonList[1].distance/sortedPersonList[0].distance))
                            .foregroundStyle(.white)
                        
                        Text("2")
                            .font(.system(size: 65))
                    }
                }
                .offset(x: -8, y: 25*(sortedPersonList[0].distance/sortedPersonList[1].distance))
            }
        }
        
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.lightGray))
                .frame(width: 375, height: 50)
            
            HStack {
                Text("You are currently rank")
                    .fontWeight(.light)
                
                Spacer()
                
                Text(String(sortedPersonList[0].distance) + " miles")
                    .fontWeight(.medium)
                
                HStack {
                    Text("1")
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
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 30, height: 30)
                        
                        Text(sortedPersonList[index].name)
                            .fontWeight(.light)
                        
                        Spacer()
                        
                        Text(String(sortedPersonList[index].distance) + " miles")
                            .fontWeight(.medium)
                        
                        HStack {
                            Text(String(index + 1))
                            Image(systemName: "arrowtriangle.up.fill")
                                .font(.system(size: 9, weight: .regular))
                                .opacity(0.5)
                        }
                        .padding(.leading, 30)
                        .fontWeight(.medium)
                        
                    }
                    .font(.system(size: 14))
                    .padding(.horizontal, 30).padding(.vertical, 5)
                    
                    Divider().frame(width: 375).overlay(.gray)
                }
            }
        }
    }
}

#Preview {
    ChalLeaderboardView(personList: [Person(name:"Ryan", distance: 4.2), Person(name:"Max", distance: 14.8), Person(name:"Jason", distance: 7.1), Person(name:"Sam", distance: 11.4), Person(name: "Joe", distance: 5.5)])
}
