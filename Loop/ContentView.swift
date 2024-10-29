//  Loop
//
//  Created by Max Ko on 9/13/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var healthKitManager = HealthKitManager.shared
    let user: User = User(uid: "user", name: "user", username: "user", profilePictureId: "None")
    var body: some View {
//        Button("Get user data") {
//            Task {
//                await user.addUser()
//                let userGot: User? = await user.getUser(uid: user.uid)
//                if let userGotUnwrapped = userGot {
//                    print("uid: \(userGotUnwrapped.uid)")
//                    print("incomingRequest: \(userGotUnwrapped.incomingRequest)")
//                    print("challengeIds: \(userGotUnwrapped.challengeIds)")
//                    print("name: \(userGotUnwrapped.name)")
//                    print("profilePictureId: \(userGotUnwrapped.profilePictureId)")
//                    print("username: \(userGotUnwrapped.username)")
//                }
//            }
//        }
//        Button("Get steps") {
//            healthKitManager.fetchAllDatas()
//        }
        Text("Hello, World!")
        
    }
}


#Preview {
    ContentView()
}
