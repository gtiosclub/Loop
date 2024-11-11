//
//  RecordViewModel.swift
//  Loop
//
//  Created by Joseph Masson on 11/6/24.
//

import Foundation
import WatchConnectivity
import HealthKit
import FirebaseFirestore
import FirebaseAuth

class RecordViewModel: NSObject, ObservableObject, WCSessionDelegate {
    // boolean from the watch to indicate if a workout is in progress
    @Published var workoutInProgress = false
    let healthStore = HKHealthStore()
    let db = Firestore.firestore()
    var uid: String?

    override init() {
        self.uid = Auth.auth().currentUser?.uid ""
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
                    self.uploadWorkoutData()
                }
            }
        }
    }

    func uploadWorkoutData() {
        let workoutType = HKObjectType.workoutType()
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        let query = HKSampleQuery(sampleType: workoutType, predicate: nil, limit: 1, sortDescriptors: [sortDescriptor]) { _, samples, error in 
            guard let samples = samples, let workout = samples.first as? HKWorkout else {
                print("No workout data found or error: \(String(describing: error?.localizedDescription))")
                return
            }

            let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let caloriesType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
            let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
            let routeType = HKSeriesType.workoutRoute()

            let heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: HKQuery.predicateForObjects(from: workout), limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
                var heartRateSamples: [HKQuantitySample] = []
                if let samples = samples as? [HKQuantitySample], !samples.isEmpty {
                    heartRateSamples = samples
                } else {
                    #if targetEnvironment(simulator)
                    let dummyHeartRate = HKQuantitySample(type: heartRateType, quantity: HKQuantity(unit: HKUnit(from: "count/min"), doubleValue: 75), start: Date(), end: Date())
                    heartRateSamples = [dummyHeartRate]
                    print("Using dummy heart rate data: \(heartRateSamples)")
                    #else
                    print("No heart rate data found or error: \(String(describing: error?.localizedDescription))")
                    return
                    #endif
                }

                let heartRates = heartRateSamples.map { $0.quantity.doubleValue(for: HKUnit(from: "count/min")) }
                let averageHeartRate = heartRates.reduce(0, +) / Double(heartRates.count)
                let heartRatePoints = heartRateSamples.map { ($0.startDate, $0.quantity.doubleValue(for: HKUnit(from: "count/min"))) }
            }

            let caloriesQuery = HKSampleQuery(sampleType: caloriesType, predicate: HKQuery.predicateForObjects(from: workout), limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
                guard let caloriesSamples = samples as? [HKQuantitySample] else {
                    print("No calories data found or error: \(String(describing: error?.localizedDescription))")
                    return
                }
                let totalCalories = caloriesSamples.map { $0.quantity.doubleValue(for: .kilocalorie()) }.reduce(0, +)
            }

            let distanceQuery = HKSampleQuery(sampleType: distanceType, predicate: HKQuery.predicateForObjects(from: workout), limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
                guard let distanceSamples = samples as? [HKQuantitySample] else {
                    print("No distance data found or error: \(String(describing: error?.localizedDescription))")
                    return
                }
                let totalDistance = distanceSamples.map { $0.quantity.doubleValue(for: .mile()) }.reduce(0, +)
            }

            let routeQuery = HKAnchoredObjectQuery(type: routeType, predicate: HKQuery.predicateForObjects(from: workout), anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, newAnchor, error) in
                guard let routeSamples = samples as? [HKWorkoutRoute] else {
                    print("No route data found or error: \(String(describing: error?.localizedDescription))")
                    return
                }

                var routeLocations: [(latitude: Double, longitude: Double)] = []
                
                for routeSample in routeSamples {
                    let routeQuery = HKWorkoutRouteQuery(route: routeSample) { (query, locations, done, error) in
                        guard let locations = locations else {
                            print("No locations data found or error: \(String(describing: error?.localizedDescription))")
                            return
                        }

                        for location in locations {
                            let coordinate = (latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                            routeLocations.append(coordinate)
                        }
                    }
                    self.healthStore.execute(routeQuery)
                    
                }
            }
            self.healthStore.execute(heartRateQuery)
            self.healthStore.execute(caloriesQuery)
            self.healthStore.execute(distanceQuery)
            self.healthStore.execute(routeQuery)

            let workoutData: [String: Any] = [
                "uid": self.uid,
                "startDate": workout.startDate,
                "endDate": workout.endDate,
                "totalEnergyBurned": workout.totalEnergyBurned?.doubleValue(for: .kilocalorie()) ?? 0,
                "totalDistance": workout.totalDistance?.doubleValue(for: .mile()) ?? 0,
                "averageHeartRate": averageHeartRate,
                "heartRatePoints": heartRatePoints.map { ["date": $0.0, "value": $0.1] },
                "routeLocations": routeLocations.map { ["latitude": $0.latitude, "longitude": $0.longitude] }
            ]

            self.db.collection("activity").addDocument(data: workoutData) { error in
                if let error = error {
                    print("Error adding document: \(error.localizedDescription)")
                } else {
                    print("Document added successfully")
                }
            }
            
        }
        healthStore.execute(query)
    }
}
