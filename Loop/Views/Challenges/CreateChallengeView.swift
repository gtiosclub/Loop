//
//  CreateChallengeView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct CreateChallengeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var challengeName: String = ""
    @State private var challengeActivity: ChallengeActivity = .Running
    @State private var challengeMetric: ChallengeMetric = .Distance
    @State private var endDate: Date = Date()
    @State private var isDatePickerVisible = false
    @State private var searchText: String = ""
    
    @State private var popUpOpen = false
    
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                
                VStack(alignment:.leading) {
                    HStack{
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .bold()
                        }
                        Text("Create a Challenge")
                            .font(.title)
                            .padding(.leading, 5)
                            .bold()
                    }
                    .frame(maxWidth:.infinity, alignment: .leading)
                    .padding(.bottom, 10)
                    
                    TextField("Enter Challenge Name", text: $challengeName)
                        .font(.title2)
                        .bold()
                        .padding(.bottom, 10)
                    
                    Rectangle()
                        .frame(maxWidth: .infinity, minHeight: 180)
                        .foregroundColor(.gray)
                        .cornerRadius(20)
                        .padding(.bottom, 20)
                    
                    //Challenge Details
                    Text("Challenge Details")
                        .font(.title2)
                        .bold()
                    
                    //End Date Select
                    HStack {
                        Text("Challenge Period: ")
                        Spacer()
                        Text("\(Date().formatted(.dateTime.day().month(.twoDigits))) - \(endDate.formatted(.dateTime.day().month(.twoDigits)))")
                        Button(action: {
                            isDatePickerVisible.toggle() // Toggle visibility of the date picker
                        }) {
                            Image(systemName: "calendar") // SF Symbol for calendar icon
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                        }
                    }
                    // DatePicker that is conditionally shown
                    if isDatePickerVisible {
                        DatePicker(
                            "End Date",
                            selection: $endDate,
                            in: Date()...,
                            displayedComponents: .date
                        )
                        .datePickerStyle(GraphicalDatePickerStyle())
                        .labelsHidden()
                    }
                    Divider()
                        .frame(height:1)
                        .background(.gray)
                    
                    //Select Activity
                    HStack {
                        Text("Challenge Activity:")
                        Spacer()
                        
                        Picker("Challenge Type", selection: $challengeActivity) {
                            Text("Running").tag(ChallengeActivity.Running)
                            Text("Biking").tag(ChallengeActivity.Biking)
                            Text("Swimming").tag(ChallengeActivity.Swimming)
                            Text("Weightlifting").tag(ChallengeActivity.Weightlifting)
                            Text("General Health")
                                .tag(ChallengeActivity.General)
                            
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(.red)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.red, lineWidth: 2)
                        )
                        
                    }
                    Divider()
                        .frame(height:1)
                        .background(.gray)
                    
                    //Select Metric
                    HStack {
                        Text("Challenge Metric:")
                        Spacer()
                        
                        Picker("Challenge Metric", selection: $challengeMetric) {
                            Text("Distance" ).tag(ChallengeMetric.Distance)
                            Text("Time").tag(ChallengeMetric.Time)
                            Text("Consecutive Days").tag(ChallengeMetric.ConsecutiveDays)
                            Text("Calories").tag(ChallengeMetric.Calories)
                            Text("Speed")
                                .tag(ChallengeMetric.Speed)
                            
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(.red)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.red, lineWidth: 2)
                        )
                        
                    }
                    Divider()
                        .frame(height:1)
                        .background(.gray)
                    
                    Text("Manage Participants")
                        .font(.title2)
                        .bold()
                        .padding(.top, 20)
                    
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundColor(.gray)
                        TextField("Search Participants", text: $searchText).padding(8).background(Color.gray.opacity(0.15)).cornerRadius(8)
                    }
                    .padding(.bottom, 15)
                    
                    Button(action: {
                        popUpOpen = true
                    }){
                        HStack {
                            Image(systemName: "plus")
                                .bold()
                            Text("Add Participants")
                                .bold()
                        }
                        .foregroundStyle(.black)
                    }
                    
                    Button(action: {}){
                        Text("CREATE CHALLENGE")
                            .font(.system(size:22))
                            .bold()
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth:.infinity, minHeight: 60, maxHeight: 60)
                    .background(.red)
                    .cornerRadius(15)
                    .padding(.vertical, 40)
                    
                }
                .padding([.leading,.trailing], 20)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .scrollIndicators(.hidden)
            
            if popUpOpen {
                Color.gray.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        popUpOpen = false
                    }
                AddParticipantView()
            }
        }
        
    }
}

enum ChallengeActivity: String, CaseIterable, Identifiable {
    var id: Self {self}
    case Running
    case Swimming
    case Weightlifting
    case Biking
    case General
}
enum ChallengeMetric: String, CaseIterable, Identifiable
{
    var id: Self {self}
    case Distance
    case Time
    case ConsecutiveDays
    case Calories
    case Speed
}

#Preview {
    CreateChallengeView()
}
