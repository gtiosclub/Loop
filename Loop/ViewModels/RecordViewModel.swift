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
    @Published var workoutInProgress = false
    let healthStore = HKHealthStore()
    let db = Firestore.firestore()
    var uid: String
    
    init(userId: String) {
            self.uid = userId
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

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate")
        session.activate()
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let workoutStarted = message["workoutStarted"] as? Bool {
            DispatchQueue.main.async {
                self.workoutInProgress = workoutStarted
                print("Received message from watch: \(workoutStarted)")
            }
        }

        if let updateFirestore = message["updateFirestore"] as? Bool {
            DispatchQueue.main.async {
                print("Received Firestore message from watch: \(updateFirestore)")
                if updateFirestore {
                    self.uploadWorkoutData()
                }
            }
        }
    }

    func workoutActivityTypeToString(_ type: HKWorkoutActivityType) -> String {
        switch type {
        case .running:
            return "running"
        case .cycling:
            return "biking"
        case .swimming:
            return "swimming"
        case .hiking:
            return "hiking"
        default:
            return "unknown"
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

            let workoutTypeString = WorkoutType(self.workoutActivityTypeToString(workout.workoutActivityType)).description()
            print("Workout type: \(workoutTypeString)")
            
            let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)!
            let caloriesType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
            let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
            let routeType = HKSeriesType.workoutRoute()

            var averageHeartRate: Double = 0
            var heartRatePoints: [(Date, Double)] = []
            var routeLocations: [(latitude: Double, longitude: Double)] = []

            let dispatchGroup = DispatchGroup()

            dispatchGroup.enter()
            let heartRateQuery = HKSampleQuery(sampleType: heartRateType, predicate: HKQuery.predicateForObjects(from: workout), limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
                defer { dispatchGroup.leave() }
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
                averageHeartRate = heartRates.reduce(0, +) / Double(heartRates.count)
                heartRatePoints = heartRateSamples.map { ($0.startDate, $0.quantity.doubleValue(for: HKUnit(from: "count/min"))) }
            }

            dispatchGroup.enter()
            let caloriesQuery = HKSampleQuery(sampleType: caloriesType, predicate: HKQuery.predicateForObjects(from: workout), limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
                defer { dispatchGroup.leave() }
                guard let caloriesSamples = samples as? [HKQuantitySample] else {
                    print("No calories data found or error: \(String(describing: error?.localizedDescription))")
                    return
                }
                let totalCalories = caloriesSamples.map { $0.quantity.doubleValue(for: .kilocalorie()) }.reduce(0, +)
            }

            dispatchGroup.enter()
            let distanceQuery = HKSampleQuery(sampleType: distanceType, predicate: HKQuery.predicateForObjects(from: workout), limit: HKObjectQueryNoLimit, sortDescriptors: nil) { (query, samples, error) in
                defer { dispatchGroup.leave() }
                guard let distanceSamples = samples as? [HKQuantitySample] else {
                    print("No distance data found or error: \(String(describing: error?.localizedDescription))")
                    return
                }
                let totalDistance = distanceSamples.map { $0.quantity.doubleValue(for: .mile()) }.reduce(0, +)
            }

            dispatchGroup.enter()
            let routeQuery = HKAnchoredObjectQuery(type: routeType, predicate: HKQuery.predicateForObjects(from: workout), anchor: nil, limit: HKObjectQueryNoLimit) { (query, samples, deletedObjects, newAnchor, error) in
                defer { dispatchGroup.leave() }
                guard let routeSamples = samples as? [HKWorkoutRoute] else {
                    print("No route data found or error: \(String(describing: error?.localizedDescription))")
                    return
                }

                for routeSample in routeSamples {
                    dispatchGroup.enter()
                    let routeQuery = HKWorkoutRouteQuery(route: routeSample) { (query, locations, done, error) in
                        defer { dispatchGroup.leave() }
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

            dispatchGroup.notify(queue: .main) {
                // Upload data to Firestore
                let workoutData: [String: Any] = [
                    "uid": self.uid,
                    "workoutType": workoutTypeString,
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
                
                print(self.uid)
                
                let userRef = self.db.collection("users").document(self.uid)
                
                userRef.collection("workouts").addDocument(data: workoutData) { error in
                    if let error = error {
                        print("Error adding workout data: \(error)")
                    } else {
                        print("Workout data successfully added!")
                    }
                }
            }
        }
        healthStore.execute(query)
    }
}
