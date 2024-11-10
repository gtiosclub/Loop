//
//  RecordViewModel.swift
//  Loop
//
//  Created by Joseph Masson on 11/6/24.
//

import Foundation
import WatchConnectivity
import HealthKit

class RecordViewModel: NSObject, ObservableObject, WCSessionDelegate {
    // boolean from the watch to indicate if a workout is in progress
    @Published var workoutInProgress = false
    let healthStore = HKHealthStore()

    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed with error: \(error.localizedDescription)")
            return
        }
        print("WCSession activated with state: \(activationState.rawValue)")
    }

    //stub methods
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate")
        // Re-activate the session
        session.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let workoutStarted = message["workoutStarted"] as? Bool {
            DispatchQueue.main.async {
                self.workoutInProgress = workoutStarted
                print("Recieved message from watch: \(workoutStarted)")
            }
        }

        if let updateFirestore = message["updateFirestore"] as? Bool {
            DispatchQueue.main.async {
                print("Recieved Firestore message from watch: \(updateFirestore)")
                if updateFirestore {
                    print("Uploading workout data to Firestore")
                    self.uploadWorkoutData()
                }
            }
        }
    }

    func uploadWorkoutData() {
        //pull workout data from HealthKit
        let workoutType = HKObjectType.workoutType()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: workoutType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in 
            guard let samples = samples, let workout = samples.first as? HKWorkout else {
                print("No workout data found or error: \(String(describing: error?.localizedDescription))")
                return
            }

            //set up the hk variables
            let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let caloriesType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
            let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
            print ("Fetched Data")

            let heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: HKQuery.predicateForObjects(from: workout), limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
                guard let heartRateSamples = samples as? [HKQuantitySample] else {
                    print("No heart rate data found or error: \(String(describing: error?.localizedDescription))")
                    return
                }

                
                let heartRates = heartRateSamples.map { $0.quantity.doubleValue(for: HKUnit(from: "count/min")) }
                let averageHeartRate = heartRates.reduce(0, +) / Double(heartRates.count)

                print("Average heart rate: \(averageHeartRate)")
                
                let caloriesQuery = HKSampleQuery(sampleType: caloriesType, predicate: HKQuery.predicateForObjects(from: workout), limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
                    guard let caloriesSamples = samples as? [HKQuantitySample] else {
                        print("No calories data found or error: \(String(describing: error?.localizedDescription))")
                        return
                    }
                    
                    let totalCalories = caloriesSamples.map { $0.quantity.doubleValue(for: .kilocalorie()) }.reduce(0, +)

                    print("Total calories: \(totalCalories)")

                    let distanceQuery = HKSampleQuery(sampleType: distanceType, predicate: HKQuery.predicateForObjects(from: workout), limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
                        guard let distanceSamples = samples as? [HKQuantitySample] else {
                            print("No distance data found or error: \(String(describing: error?.localizedDescription))")
                            return
                        }
                        
                        let totalDistance = distanceSamples.map { $0.quantity.doubleValue(for: .mile()) }.reduce(0, +)
                        print("Total distance: \(totalDistance)")
                    }
                    self.healthStore.execute(distanceQuery)
                }
                self.healthStore.execute(caloriesQuery)
            }
            self.healthStore.execute(heartRateQuery)
        }
        healthStore.execute(query)
        
    }
}
