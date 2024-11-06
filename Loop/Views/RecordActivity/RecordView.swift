//
//  RecordView.swift
//  Loop
//
//  Created by Ryan O’Meara on 10/22/24.
//

import SwiftUI
import WatchConnectivity

struct RecordView: View {
    @StateObject private var viewModel = RecordViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.workoutInProgress {
                    Text("Workout in Progress")
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(8)
                        .padding(.top)
                }
            }.navigationTitle("Record View")
        }
    }
}

#Preview {
    RecordView()
}
