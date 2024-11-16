//
//  ActivityRingsView.swift
//  LoopWatchApp Watch App
//
//  Created by Nitya Potti on 10/29/24.
//

import Foundation
import HealthKit
import SwiftUI

public struct ActivityRingsView: WKInterfaceObjectRepresentable {
    
    
    let healthStore: HKHealthStore
    public func makeWKInterfaceObject(context: Context) -> some WKInterfaceObject {
        let activityRingsObject = WKInterfaceActivityRing()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.era, .year, .month, .day],
                                                 from: Date())
        components.calendar = calendar
        let predicate = HKQuery.predicateForActivitySummary(with: components)
        let query = HKActivitySummaryQuery(predicate: predicate) { query, summaries, error in
            DispatchQueue.main.async {
                activityRingsObject.setActivitySummary(summaries?.first, animated: true)
            }
        }
        healthStore.execute(query)
        return activityRingsObject
    }
    public func updateWKInterfaceObject(_ wkInterfaceObject: WKInterfaceObjectType, context: Context) {

    }
    
}
