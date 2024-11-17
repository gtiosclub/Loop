//
//  ChallengeListView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct ChallengeListView: View {
    @ObservedObject var user = User.shared
        
    var challenges: [Challenge] {
        return user.challenges
    }
        
    //Joining a challenge variables
    @State private var isShowingJoin = false
    @State private var accessCode = ""
    @State private var isLoadingJoin = false
    @State private var joinErrorMessage: String?
    @State private var selectedTab: String = "Active Challenges"
    var tabs = ["Active Challenges", "Past Challenges"]
    
    var body: some View {
        ZStack {
            NavigationStack {
                HStack {
                    Text("Challenges")
                        .font(.system(size: 26, weight: .medium))
                        .padding(.leading, 15)
                    
                    Spacer()
                    
                    Button {
                        isShowingJoin.toggle()
                    } label: {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:20, height: 20)
                            .bold()
                            .foregroundStyle(.black)
                    }
                    
                    NavigationLink {
                        CreateChallengeView()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 21))
                    }
                    .padding(.trailing, 16)
                }
                
                HStack {
                    ForEach(tabs, id: \.self) { tab in
                        if (tab == selectedTab) {
                            Text(tab)
                                .font(.system(size: 17, weight: .medium))
                                .frame(width: UIScreen.main.bounds.size.width / 2, alignment: .center)
                                .overlay(VStack {
                                    Divider().frame(height: 2).background(Color.black).offset(x: 0, y: 20)
                                })
                        } else {
                            Button {
                                selectedTab = tab
                            } label: {
                                Text(tab)
                                    .foregroundStyle(.gray)
                                    .frame(width: UIScreen.main.bounds.size.width / 2, alignment: .center)
                                    .overlay(VStack {
                                        Divider().frame(height: 2).background(Color.gray).opacity(0.5).offset(x: 0, y: 20)
                                    })
                            }
                        }
                    }
                    .padding(.horizontal, -4)
                }
                .padding(.top, 1).padding(.bottom, 10)
                
                ScrollView {
                    ForEach(challenges, id: \.id) { challenge in
                        CardView(challenge: challenge)
                            .padding(.bottom, 5)
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.top, 10).padding(.horizontal, 10)
            }
            .foregroundColor(.black)
            
            if isShowingJoin {
                ZStack {
                    Color(.gray).opacity(0.5).ignoresSafeArea().onTapGesture {
                        isShowingJoin.toggle()
                    }
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color(red: 0.99, green: 0.99, blue: 0.99))
                        .frame(width: 350, height: 100)
                        .overlay {
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("Enter Access Code")
                                        .font(.system(size: 25, weight: .bold, design: .rounded))
                                        .foregroundStyle(.black)
                                        .padding(.top, 2)
                                    Spacer()
                                    Button {
                                        isShowingJoin.toggle()
                                    } label: {
                                        Image(systemName: "x.circle")
                                            .foregroundStyle(.white)
                                    }
                                }
                                if let error = joinErrorMessage {
                                    Text(error)
                                        .foregroundStyle(.red)
                                        .font(.system(size: 10))
                                }
                                
                                Spacer()
                                HStack {
                                    TextField("Code", text: $accessCode)
                                        .textFieldStyle(.roundedBorder)
                                    
                                    Button {
                                        Task {
                                            withAnimation {
                                                isLoadingJoin = true
                                                joinErrorMessage = nil
                                            }
                                            do {
                                                try await FirebaseManager.joinChallengeWithCode(accessCode)
                                                print("Success?")
                                                
                                            } catch _ as FirebaseManager.FirestoreFetchError {
                                                withAnimation {
                                                    joinErrorMessage = "No challege found with that access code"
                                                }
                                                
                                            } catch {
                                                print("ERROR: \(error.localizedDescription)")
                                                withAnimation {
                                                    joinErrorMessage = error.localizedDescription
                                                }
                                            }
                                            withAnimation {
                                                isLoadingJoin = false
                                            }
                                            
                                        }
                                    } label: {
                                        if isLoadingJoin {
                                            ProgressView()
                                            //                                                .frame(width: 50, height: 50)
                                        } else {
                                            Text("Join")
                                                .foregroundStyle(.black)
                                        }
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .disabled(accessCode.isEmpty)
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 25)
                        }
                }
            }
        }
    }
}

#Preview {
    ChallengeListView()
}
