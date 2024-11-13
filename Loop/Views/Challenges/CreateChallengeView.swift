//
//  CreateChallengeView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct CreateChallengeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var challengeName: String = ""
    @State private var challengeActivity: ChallengeActivity = .Running
    @State private var challengeMetric: ChallengeMetric = .Distance
    @State private var endDate: Date = Date()
    @State private var isDatePickerVisible = false
    @State private var searchText: String = ""
    @State private var joinCode: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    func createChallege() async {
        let db = Firestore.firestore()
        
        //check if access code already exists
        db.collection("challenges")
            .whereField("accessCode", isEqualTo: joinCode)
            .getDocuments { (querySnaphot, error) in
                if let error = error {
                    print("Error retrieving documents: \(error)")
                    return
                }
            //if document exists with same access code
                if let documents = querySnaphot?.documents, !documents.isEmpty {
                    //access code already exists
                    self.alertMessage = "A challenge with access code \(joinCode) already exists. Please use a different code."
                    self.showAlert = true
                    return
                } else {
                    Task {
                        var challenge =
                        Challenge(
                            title: challengeName,
                            host: User.shared.uid,
                            attendees: [User.shared.uid],
                            challengeType: challengeActivity.rawValue,
                            lengthInMinutes: 0,
                            dataMeasured: challengeMetric.rawValue,
                            endDate: endDate,
                            theme: .bubblegum,
                            accessCode: joinCode,
                            scores: [User.shared.uid:0]
                        )
                        
                        challenge.attendeesFull.append(Person(id: User.shared.uid, name: User.shared.username, score: 0))
                        
                        if let challengeId = await challenge.addChallenge() {
                            print("Challenge created with ID: \(challengeId)")
                            _ = await User.shared.addChallenge(challenge: challenge)
                            dismiss()
                        } else {
                            print("Failed to create challenge")
                        }
                    }
                }
            }
    }
    
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
                    
                    Text("Challenge Details")
                        .font(.title2)
                        .bold()
                    
                    HStack {
                        Text("Challenge Period: ")
                        Spacer()
                        Text("\(Date().formatted(.dateTime.day().month(.twoDigits))) - \(endDate.formatted(.dateTime.day().month(.twoDigits)))")
                        Button(action: {
                            isDatePickerVisible.toggle()
                        }) {
                            Image(systemName: "calendar")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.red)
                        }
                    }
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
                    
                    
                    Text("Create Join Code")
                        .font(.title2)
                        .bold()
                        .padding(.top, 20)
                    
                    HStack{
                        TextField("Join Code", text: $joinCode)
                            .font(.title3)
                            .bold()
                            .padding(10)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.black, lineWidth:1)
                            .padding(1)
                    )
                    
                    }
                    
                    Button(action: {
                        Task {
                            await createChallege()
                        }
                    }){
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .scrollIndicators(.hidden)
            
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

//struct ParticipantCardView: View {
//    let name: String
//    let email: String
//
//    var body: some View {
//        HStack {
//            Circle()
//                .fill(.gray)
//                .frame(width:40, height: 40)
//
//            VStack(alignment: .leading){
//                Text(name)
//                Text(email)
//                    .opacity(0.5)
//            }
//            .padding(.leading, 15)
//            Spacer()
//            Button {
//
//            } label: {
//                Text("Remove")
//                    .foregroundColor(.black)
//            }
//            .frame(width: 100, height: 40)
//            .background(.gray)
//            .opacity(0.6)
//            .cornerRadius(10)
//        }
//        .frame(height:50)
//    }
//}

#Preview {
    CreateChallengeView()
}
