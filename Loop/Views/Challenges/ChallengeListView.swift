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
    
    var body: some View {
        ZStack {
            NavigationStack {
                HStack {
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
                    .padding(.horizontal, 5)
                    
                    NavigationLink {
                        CreateChallengeView()
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width:20, height: 20)
                            .bold()
                            .foregroundStyle(.black)
                    }
                    .padding(.trailing, 30)
                }
                Text("Challenges")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 20)
                
                if user.challenges.isEmpty {
                    Text("JOIN SOME CHALLENGES!")
                        .font(.title)
                        .bold()
                        .foregroundStyle(.black)
                }
                List {
                    ForEach(user.challenges, id: \.id) { challenge in
                        NavigationLink {
                            ChallengeView(challenge: challenge)
                        } label: {
                            CardView(challenge: challenge)
                        }
                        .listRowBackground(challenge.theme.mainColor)
                    }
                }
                
            }
            .allowsHitTesting(!isShowingJoin)
            
            if isShowingJoin {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundStyle(Color(red: 0.3, green: 0.3, blue: 0.3))
                        .frame(width: 350, height: 100)
                        .overlay {
                            VStack {
                                HStack {
                                    Spacer()
                                    Text("Enter access code")
                                        .font(.system(size: 25, weight: .bold, design: .rounded))
                                        .foregroundStyle(.white)
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
                                    TextField("access code", text: $accessCode)
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
                                                
                                            } catch let firestoreError as FirebaseManager.FirestoreFetchError {
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
                                            Text("Search")
                                                .foregroundStyle(.white)
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
