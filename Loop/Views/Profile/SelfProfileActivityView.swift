//
//  SelfProfileActivityView.swift
//  Loop
//
//  Created by Seohyun Park on 10/29/24.
//

import SwiftUI

struct SelfProfileActivityView: View {
    @State private var name: String = "Jane Doe"
    @State private var wins: Int = 0
    @State private var activityName: String = "Physical Activity"
    @State private var competitionName: String = "Competition Name"
    @State private var time: String = "Today at 9:16 PM"

    var body: some View {
        VStack {
            VStack {
                ForEach(1...3, id: \.self) { index in
                    VStack(spacing: 10) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                            Text(name)
                                .font(.subheadline)
                            Spacer()
                            Text(activityName)
                                .font(.subheadline)
                        }.padding([.leading, .trailing, .top])
                        
                        Divider()
                            .frame(height: 2)
                            .background(Color.gray)
                        
                        Text(competitionName)
                                .font(.title2)
                        
                        Image("pedestal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 150)
                        
                        Text(name + " Placed 1st!")
                                .font(.title2)
                        
                        HStack {
                            Text(time)
                            .font(.caption)
                        Spacer()
            
                        Image(systemName: "eye.slash")
                        }.padding()
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)

                    Spacer().frame(height: 15)
                }
            }
        }.padding()
    }
}

#Preview {
    SelfProfileActivityView()
}
