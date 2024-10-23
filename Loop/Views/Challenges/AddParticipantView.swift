//
//  AddParticipantView.swift
//  Loop
//
//  Created by Ryan O’Meara on 10/22/24.
//

import SwiftUI

struct AddParticipantView: View {
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    @State private var searchText: String = ""
    
    
    var body: some View {
        ZStack { //Only for testing
            ZStack(alignment: .top) {
                VStack {
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width:25)
                                .foregroundColor(.black)
                                .bold()
                                .padding(.trailing, 10)
                        }
                        Text("Add Participants")
                            .font(.title)
                            .bold()
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "magnifyingglass").foregroundColor(.gray)
                        TextField("Search Friends", text: $searchText).padding(8).background(Color.gray.opacity(0.15)).cornerRadius(8)
                    }
                    .padding(.bottom, 10)
                    
                    ScrollView {
                        FriendCardView(name:"Joshua Oliver", email: "jollie6@gmail.com")
                        FriendCardView(name:"Joshua Oliver", email: "jollie6@gmail.com")
                        FriendCardView(name:"Joshua Oliver", email: "jollie6@gmail.com")
                        FriendCardView(name:"Joshua Oliver", email: "jollie6@gmail.com")
                        FriendCardView(name:"Joshua Oliver", email: "jollie6@gmail.com")
                        FriendCardView(name:"Joshua Oliver", email: "jollie6@gmail.com")
                        FriendCardView(name:"Joshua Oliver", email: "jollie6@gmail.com")
                        FriendCardView(name:"Joshua Oliver", email: "jollie6@gmail.com")
                        FriendCardView(name:"Joshua Oliver", email: "jollie6@gmail.com")
                        FriendCardView(name:"Joshua Oliver", email: "jollie6@gmail.com")
                        FriendCardView(name:"Joshua Oliver", email: "jollie6@gmail.com")
                        FriendCardView(name:"Joshua Oliver", email: "jollie6@gmail.com")
                        FriendCardView(name:"Joshua Oliver", email: "jollie6@gmail.com")
                    }
                    .scrollIndicators(.hidden)
                    
                    
                    Spacer()
                }
                .padding(20)
            }
            .frame(width: screenWidth, height: screenHeight * 0.75)
            .background(.white)
            .cornerRadius(30)
            .offset(y:screenHeight * 0.75/2 - 100)
        } // only for testing, delete
//        .background(.red) //delete
    }
}

struct FriendCardView: View {
    let name: String
    let email: String
    
    var body: some View {
        HStack {
            Circle()
                .fill(.gray)
                .frame(width:40, height: 40)
            
            VStack(alignment: .leading){
                Text(name)
                Text(email)
                    .opacity(0.5)
            }
            .padding(.leading, 15)
            Spacer()
            Button {
                
            } label: {
                Text("Invite")
                    .foregroundColor(.black)
            }
            .frame(width: 100, height: 40)
            .background(.gray)
            .opacity(0.6)
            .cornerRadius(10)
        }
        .frame(height:50)
    }
}

#Preview {
    AddParticipantView()
}
