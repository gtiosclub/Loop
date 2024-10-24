//
//  LoopWatchAppApp.swift
//  LoopWatchApp Watch App
//
//  Created by Matt Free on 9/26/24.
//

import SwiftUI

@main
struct LoopWatchApp_Watch_AppApp: App {
    @StateObject var manager = HealthManager()
    var body: some Scene {
        WindowGroup {
            WatchTypesOfExerciseView()
                .environmentObject(manager)
        }
    }
}
