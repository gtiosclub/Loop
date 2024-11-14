//
//  PodiumView.swift
//  Loop
//
//  Created by Jason Wrzesien on 10/29/24.
//

import SwiftUI

struct PodiumView: View {
    var personList: [Person]
    
    var body: some View {
        HStack {
            //Third Place
            if (personList.count > 2) {
                VStack {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 65, height: 65)
                    
                    Text(personList[2].name)
                        .font(.system(size: 16, weight: .light))
                        .padding(.bottom, -1)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .fill(Color(.lightGray))
                            .frame(width: 90, height: 25)
                        
                        Text(String(personList[2].score) + " miles")
                            .font(.system(size: 12, weight: .light))
                    }
                    .padding(.bottom, -5)
                    
                    ZStack {
                        Rectangle()
                            .stroke(Color.black, style: StrokeStyle(lineWidth: 3))
                            .frame(width: 125, height: 100)
                            .offset(x: 0, y: -4)
                        
                        Rectangle()
                            .frame(width: 122, height: 105)
                            .foregroundStyle(.white)
                        
                        Text("3")
                            .font(.system(size: 65, weight: .light))
                    }
                }
                .offset(x: 8, y: 50)
            }
            //First Place
                VStack {
                    Circle()
                        .foregroundColor(.gray)
                        .frame(width: 90, height: 90)
                    
                    Text(personList[0].name)
                        .font(.system(size: 16, weight: .light))
                        .padding(.bottom, -1)
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .fill(Color(.lightGray))
                            .frame(width: 90, height: 25)
                        
                        Text(String(personList[0].score) + " miles")
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
                //Second Place
                if (personList.count > 1) {
                    VStack {
                        Circle()
                            .foregroundColor(.gray)
                            .frame(width: 65, height: 65)
                        
                        Text(personList[1].name)
                            .font(.system(size: 16, weight: .light))
                            .padding(.bottom, -1)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(Color(.lightGray))
                                .frame(width: 90, height: 25)
                            
                            Text(String(personList[1].score) + " miles")
                                .font(.system(size: 12, weight: .light))
                        }
                        .padding(.bottom, -5)
                        
                        ZStack {
                            Rectangle()
                                .stroke(Color.black, style: StrokeStyle(lineWidth: 3))
                                .frame(width: 125, height: 120)
                                .offset(x: 0, y: -4)
                            
                            Rectangle()
                                .frame(width: 122, height: 125)
                                .foregroundStyle(.white)
                            
                            Text("2")
                                .font(.system(size: 65))
                        }
                    }
                    .offset(x: -8, y: 40)
                }
            }
        }
    }

#Preview {
    PodiumView(personList: [Person(name:"Max", score: 14.8), Person(name:"Sam", score: 11.4), Person(name:"Jason", score: 7.1), Person(name:"Ryan", score: 4.2), Person(name: "Joe", score: 5.5)])
}
