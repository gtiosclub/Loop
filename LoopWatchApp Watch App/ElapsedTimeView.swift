//
//  ElapsedTimeView.swift
//  Loop
//
//  Created by Nitya Potti on 11/1/24.
//


import SwiftUI

struct ElapsedTimeView: View {
    var elapsedTime: TimeInterval = 0
    var showSubseconds: Bool = true
    @State private var timeFormatter = ElapsedTimeFormatter()
    
    var body: some View {
        Text(timeFormatter.string(from: elapsedTime))
            .fontWeight(.semibold)
            .onChange(of: showSubseconds) {
                timeFormatter.showSubseconds = $0
            }
    }
}

struct ElapsedTimeFormatter {
    var showSubseconds: Bool = true

    func string(from time: TimeInterval) -> String {
        let componentsFormatter = DateComponentsFormatter()
        componentsFormatter.allowedUnits = [.minute, .second]
        componentsFormatter.zeroFormattingBehavior = .pad
        
        guard let formattedString = componentsFormatter.string(from: time) else {
            return "Invalid time"
        }
        
        if showSubseconds {
            let hundredths = Int((time * 100).truncatingRemainder(dividingBy: 100))
            let decimalSeparator = Locale.current.decimalSeparator ?? "."
            let formattedHundredths = String(format: "%02d", hundredths)
            
            return String(format: "%@%@%@", formattedString, decimalSeparator, formattedHundredths)
        }
        
        return formattedString
    }
}
