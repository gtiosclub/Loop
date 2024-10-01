//
//  ContentView.swift
//  Loop
//
//  Created by Max Ko on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    var challenge = Challenges(challengeName: "challenge", challengeType: "cardio", challengeStart: Date(), challengeEnd: Date(), host: "host");
    
    var body: some View {
        VStack {
            Button("Add user to db") {
                Task {
                    await print(challenge.addChallenge());
                }
            }
            Button("Get challenge data") {
                Task {
                    await print(challenge.getChallenge(challenge.challengeId));
                }
            }
            Button("Remove challenge") {
                Task {
                    await print(challenge.removeChallenge(challenge.challengeId));
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
