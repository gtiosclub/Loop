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
            return Color("bubblegum")
        case .buttercup:
            return Color("buttercup")
        case .indigo:
            return Color.indigo
        case .lavender:
            return Color("lavender")
        case .magenta:
            return Color("magenta")
        case .navy:
            return Color("navy")
        case .orange:
            return Color.orange
        case .oxblood:
            return Color("oxblood")
        case .periwinkle:
            return Color("periwinkle")
        case .purple:
            return Color.purple
        case .seafoam:
            return Color("seafoam")
        case .sky:
            return Color("sky")
        case .tan:
            return Color("tan")
        case .teal:
            return Color.teal
        case .yellow:
            return Color.yellow
        }
    }
}
