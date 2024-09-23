//
//  TrailingIconLabelStyle.swift
//  Loop
//
//  Created by joey on 9/23/24.
//

import SwiftUI

// A style to enable icon styling for the card later on
struct TrailingIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.title
            configuration.icon
        }
    }
}


extension LabelStyle where Self == TrailingIconLabelStyle {
    static var trailingIcon: Self { Self() }
}
