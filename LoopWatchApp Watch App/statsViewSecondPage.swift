//
//  statsViewSecondPage.swift
//  LoopWatchAssignment Watch App
//
//  Created by Nitya Potti on 10/8/24.
//

import Foundation

import SwiftUI

struct statsViewSecondPage: View {
    
    @Binding var isTimerRunning: Bool
        
        var body: some View {
            VStack {
                Button(action: {
                    isTimerRunning.toggle()
                }) {
                    Image(systemName: isTimerRunning ? "xmark.circle.fill" : "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(isTimerRunning ? .red : .green)
                }
                .padding()
            }
        }
}