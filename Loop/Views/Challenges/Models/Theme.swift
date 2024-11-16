//
//  Theme.swift
//  Loop
//
//  Created by joey on 9/23/24.
//

import SwiftUI

enum Theme: String {
    case bubblegum
    case buttercup
    case indigo
    case lavender
    case magenta
    case navy
    case orange
    case oxblood
    case periwinkle
    case purple
    case seafoam
    case sky
    case tan
    case teal
    case yellow
    
    var accentColor: Color {
        switch self {
        case .bubblegum, .buttercup, .lavender, .orange, .periwinkle, .seafoam, .sky, .tan, .teal, .yellow:
            return .black
        case .indigo, .magenta, .navy, .oxblood, .purple:
            return .white
        }
    }

    var mainColor: Color {
        switch self {
        case .bubblegum:
            return Color.pink
        case .buttercup:
            return Color.brown
        case .indigo:
            return Color.indigo
        case .lavender:
            return Color.green
        case .magenta:
            return Color.green
        case .navy:
            return Color.blue
        case .orange:
            return Color.orange
        case .oxblood:
            return Color.red
        case .periwinkle:
            return Color.mint
        case .purple:
            return Color.purple
        case .seafoam:
            return Color.mint
        case .sky:
            return Color.cyan
        case .tan:
            return Color.cyan
        case .teal:
            return Color.teal
        case .yellow:
            return Color.yellow
        }
    }
}
