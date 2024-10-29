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
    @State private var activityName: String = "No recent activity"    
    var body: some View {
        VStack {
            VStack {
                ForEach(1...3, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                            Text(name)
                                .font(.subheadline)
                            Spacer()
                        }.padding(.horizontal)
                        
                        Text(activityName)
                            .font(.headline)
                            .padding(.horizontal)
                        
                        HStack {
                            Image(systemName: "chart.bar.fill")
                                .resizable()
                                .frame(width: 80, height: 40)
                                .padding(.horizontal)
                            Text( name + " Placed 1st!")
                                .font(.headline)
                            Spacer()
                        }.padding(.horizontal)
            
                        HStack {
                            Text("Today at 9:16 PM")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        Spacer()
            
                        Image(systemName: "eye.slash.fill")
                                .padding(.horizontal)
                        }
                    }
                    .padding()
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
