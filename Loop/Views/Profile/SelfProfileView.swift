//
//  SelfProfileView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct SelfProfileView: View {
    @State private var name: String = "Jane Doe"
    @State private var location: String = "Atlanta, GA"
    @State private var createdDate: String = "Oct 2024"
    @State private var following: Int = 30
    @State private var followers: Int = 30
    @State private var selectedTab = 0
    @State private var currentUserUID: String = ""
    @State private var userId: String
    @State private var showingErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var selfUser: User?
    @State private var numFriends: Int = 0
    private let db = Firestore.firestore()
    
    init(userId: String) {
        self.userId = userId
    }
    
    private func getCurrentUserUID() -> String {
        if let uid = UserDefaults.standard.string(forKey: "currentUserUID") {
            return uid
        } else {
            let uid = UUID().uuidString
            UserDefaults.standard.set(uid, forKey: "currentUserUID")
            return uid
        }
    }

    private func ensureUserDocumentExists() {
        let userRef = db.collection("users").document(currentUserUID)
        userRef.getDocument { snapshot, error in
            if let error = error {
                print("Error checking user document: \(error.localizedDescription)")
                self.errorMessage = "Failed to verify user data."
                self.showingErrorAlert = true
                return
            }

            if snapshot?.exists == false {
                // Create a new user document with default fields
                userRef.setData([
                    "name": "Me",
                    "incomingRequests": [],
                    "friends": []
                ]) { error in
                    if let error = error {
                        print("Error creating user document: \(error.localizedDescription)")
                        self.errorMessage = "Failed to initialize your user data."
                        self.showingErrorAlert = true
                    } else {
                        print("User document created successfully.")
                    }
                }
            } else {
                print("User document already exists.")
            }
        }
    }
    
    func getUser(uid: String) async -> User? {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)
        do {
          let document = try await docRef.getDocument()
          if document.exists {
              let dataDescription = document.data()
              if let data = dataDescription {
                  let name: String = data["name"] as! String
                  let username: String = data["username"] as! String
                  let challengeIds: [String] = data["challengeIds"] as! [String]
                  let profilePictureId: String = data["profilePictureId"] as! String
                  let friends: [String] = data["friends"] as! [String]
                  let incomingRequest: [String] = data["incomingRequest"] as! [String]
                  return User(uid: uid, name: name, username: username, challengeIds: challengeIds, profilePictureId: profilePictureId, friends: friends, incomingRequest: incomingRequest)
              } else {
                  print("User's data in Firestore Database is nil.")
              }
          } else {
              print("User does not exist in the Firestore Database.")
          }
        } catch {
            print("Error getting user from the Firestore Database: \(error).")
        }
        return nil
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer().frame(width: 20)
                Circle()
                    .frame(width: 70, height: 70)
                    .foregroundColor(.gray)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack {
                        Text(location)
                            .padding(3)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                        
                        Spacer().frame(width: 18)
                        
                        Text(createdDate)
                            .padding(3)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(4)
                    }
                    .font(.subheadline)
                }
                
                Spacer()
                VStack {
                    NavigationLink(destination: SettingsView()) {
                        VStack(spacing: 5) {
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(.black)
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(.black)
                            Rectangle()
                                .frame(height: 4)
                                .foregroundColor(.black)
                        }
                        .frame(width: 30)
                        .padding(.trailing, 20)
                    }
                }
                .padding(.bottom, 20)
            }
            HStack {
                Spacer().frame(width: 20)

                NavigationLink(destination: ManageFriendsView(userId: selfUser?.uid ?? "", friends: selfUser?.friends ?? [])) {
                    VStack(alignment: .leading) {
                        Text("Friends")
                            .font(.subheadline)
                        
                        Text("\(numFriends)")
                            .fontWeight(.bold)
                    }
                }.foregroundStyle(.black)
                
                Spacer()
                NavigationLink(destination: AddFriendsView()){
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color(UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)))
                            .frame(width: 35, height: 35)
                            .cornerRadius(10)
                        Image(systemName: "person.badge.plus")
                            .foregroundStyle(.black)
                    }
                }
            }.padding([.leading, .trailing])
            VStack {
                Spacer()
                Text("Activity")
                    .foregroundColor(selectedTab == 0 ? .black : .gray)
                
                ScrollView {
                    SelfProfileActivityView()
                }
                
                Spacer()
            }
            
        }.onAppear() {
            self.currentUserUID = getCurrentUserUID()
            // Ensure the current user's document exists in Firestore
            ensureUserDocumentExists()
            Task {
                let user = await getUser(uid: userId)
                self.selfUser = user
                self.name = selfUser?.name ?? ""
                self.numFriends = selfUser?.friends.count ?? 0
            }
            
        }
    }
}



#Preview {
    //SelfProfileView()
}
