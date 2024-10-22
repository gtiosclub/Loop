//
//  ChallengeListView.swift
//  Loop
//
//  Created by Ryan O’Meara on 9/19/24.
//

import SwiftUI

struct ChallengeListView: View {

    let challenges: [Challenge] 
    var body: some View {

        NavigationStack {
            HStack {
                Spacer()
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
            List {
                ForEach(challenges, id: \.id) { challenge in
                    NavigationLink {
                        ChallengeView(challenge: challenge)
                    } label: {
                        CardView(challenge: challenge)
                    }
                    .listRowBackground(challenge.theme.mainColor)
                    }
                }
            
            }
        }
    }

#Preview {
    ChallengeListView(challenges: Challenge.sampleData)
}
