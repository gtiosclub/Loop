//
//  excercise.swift
//  LoopWatchAssignment Watch App
//
//  Created by Nitya Potti on 10/7/24.
//

import Foundation
import SwiftUI


@Observable
class excercise: Identifiable {
    var type: String
    var image: String
    init(type: String, image: String) {
        self.type = type
        self.image = image
    }
}
