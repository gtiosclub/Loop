//
//  ContentView.swift
//  Loop
//
//  Created by Max Ko on 9/13/24.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    var heartRate: HKStatistics?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
