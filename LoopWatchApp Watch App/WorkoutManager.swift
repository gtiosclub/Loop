//
//  WorkoutManager.swift
//  Loop
//
//  Created by Joseph Masson on 10/23/24.
//

import CoreLocation
import HealthKit
import SwiftUI
import os
import WatchConnectivity

enum WorkoutType {
    case running(HKWorkoutActivityType, HKQuantityType, HKWorkoutSessionLocationType)
    case biking(HKWorkoutActivityType, HKQuantityType, HKWorkoutSessionLocationType)
    case swimming(HKWorkoutActivityType, HKQuantityType, HKWorkoutSwimmingLocationType)
    case hiking(HKWorkoutActivityType, HKQuantityType, HKWorkoutSessionLocationType)

    init(_ type: String) {
        switch type {
        case "running":
            self = .running(HKWorkoutActivityType.running,
                            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                            HKWorkoutSessionLocationType.outdoor)
        case "biking":
            self = .biking(HKWorkoutActivityType.cycling,
                           HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
                           HKWorkoutSessionLocationType.outdoor)
        case "swimming":
            self = .swimming(HKWorkoutActivityType.swimming,
                             HKQuantityType.quantityType(forIdentifier: .distanceSwimming)!,
                             HKWorkoutSwimmingLocationType.pool)
        case "hiking":
            self = .hiking(HKWorkoutActivityType.hiking,
                           HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                           HKWorkoutSessionLocationType.outdoor)
        default:
            fatalError("Unsupported workout type")
        }
    }
    
    func getType() -> HKWorkoutActivityType {
        switch self {
        case .running(let type, _, _),
            .biking(let type, _, _),
            .swimming(let type, _, _),
            .hiking(let type, _, _):
            return type
        }
    }
    
    func getQuantityType() -> HKQuantityType{
        switch self {
        case .running(_, let quantityType, _),
            .biking(_, let quantityType, _),
            .swimming(_, let quantityType, _),
            .hiking(_, let quantityType, _):
            return quantityType
        }
    }
    
    func getLocation() -> Any {
        switch self {
        case .running(_, _, let location),
            .biking(_, _, let location),
            .hiking(_, _, let location):
            return location as Any
        case .swimming(_, _, let location):
            return location as Any
        }
    }
    
    func configure() -> HKWorkoutConfiguration {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = getType()
        switch self {
        case .running,
            .biking,
            .hiking:
            configuration.locationType = getLocation() as! HKWorkoutSessionLocationType
        case .swimming:
            configuration.swimmingLocationType = getLocation() as! HKWorkoutSwimmingLocationType
            configuration.lapLength = HKQuantity(unit: HKUnit.mile(), doubleValue: 0.1)
        }
        return configuration
    }

    func description() -> String {
        switch self {
        case .running(_, _, let location):
            return "Running"
        case .biking(_, _, let location):
            return "Biking"
        case .swimming(_, _, let location):
            return "Swimming"
        case .hiking(_, _, let location):
            return "Hiking"
        }
    }
    
}


class WorkoutManager: NSObject, ObservableObject, WCSessionDelegate {
    //Ignore all of the if-else OS blocks - iOS doesn't support a lot of these HK methods
    // but it needs to see this class to compile.

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        print("Session started from Watch")
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        //stub method
        print("Session Became Inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        //stub method
        print("Session Deactivated")
    }
    #endif
    
    @Published var isRunning = false
    @Published var isPaused = false
    @Published var distance = 0.0
    @Published var calories = 0.0
    @Published var isWorkoutInProgress = false

    //In-Progress Properties
    @Published var currentDistance: Double = 0
    @Published var currentCalories: Double = 0
    @Published var currentHeartRate: Double = 0
    @Published var currentPace: Double = 0
    @Published var totatlTime: TimeInterval = 0
    
    @Published var heartRatePoints: [(Date, Double)] = []
    @Published var routePoints: [CLLocation] = []
        
    // Location manager for map
    private let locationManager = CLLocationManager()
    
    private var pauseDate: Date?
    private var accumulatedTime: TimeInterval = 0
    @Published var totalTime: TimeInterval = 0
    
    private var timer: Timer?
    private var dataSendTimer: Timer?
    
    static let shared = WorkoutManager()
    private let healthStore = HKHealthStore()
    private var session: HKWorkoutSession?
    @Published var showingSummaryView: Bool = false {
        didSet {
            if showingSummaryView == false {
                resetWorkout()
                
            }
        }
    }

    #if os(watchOS)
    var builder: HKLiveWorkoutBuilder?
    #endif
    // Init the WC session
    override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    

    func startWorkout(_ workoutType: String) {
        #if os(watchOS)
        distance = 0
        calories = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                    self?.updateTotalTime()
                }
        
        dataSendTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.sendWorkoutData()
        }

        let configuration:HKWorkoutConfiguration = WorkoutType(workoutType.lowercased()).configure()

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()

            session?.delegate = self
            builder?.delegate = self

            builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore, workoutConfiguration: configuration)

            session?.startActivity(with: Date())
            
            guard CLLocationManager.locationServicesEnabled() else {
                print("Location services are not enabled")
                return
            }
            
            print("Location services are enabled")
            locationManager.requestWhenInUseAuthorization() // Ensure background location permission
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            
            builder?.beginCollection(withStart: Date(), completion: { (success, error) in
                DispatchQueue.main.sync {
                    self.isRunning = true
                    self.isPaused = false
                    // communication variables
                    self.isWorkoutInProgress = true
                    self.sendWorkoutStartedMessage(workoutType: workoutType)
                    print("Successfully started workout")
                }
            })

        } catch {
            print("Failed to start workout: \(error.localizedDescription)")
        }
        #endif
    }

    // Functions to send the boolean via WC
    private func sendWorkoutStartedMessage(workoutType: String) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["workoutStarted": true], replyHandler: nil, errorHandler: { error in
                print("Error sending message: \(error.localizedDescription)")
            })
            
            print("workoutType \(workoutType)")
                                           
            WCSession.default.sendMessage(["workoutType": workoutType], replyHandler: nil, errorHandler: { error in
               print("Error sending message: \(error.localizedDescription)")
            })

            WCSession.default.sendMessage(["updateFirestore": false], replyHandler: nil, errorHandler: { error in
                print("Error sending message: \(error.localizedDescription)")
            })


        } else {
            print("Session is not reachable")
        }
    }

    private func sendWorkoutEndedMessage() {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["workoutStarted": false], replyHandler: nil, errorHandler: { error in
                print("Error sending message: \(error.localizedDescription)")
            })


            WCSession.default.sendMessage(["updateFirestore": true], replyHandler: nil, errorHandler: { error in
                print("Error sending message: \(error.localizedDescription)")
            })
            print("Message sent")

        } else {
            print("Session is not reachable")
        }
    }

    func pauseWorkout() {
        #if os(watchOS)
        guard let session = session else { return }
        
        if session.state == .running {
            session.pause()
            pauseDate = Date()  // Store pause time
            timer?.invalidate()  // Stop the timer
            
            DispatchQueue.main.async {
                print("Session paused on Queue")
                self.isPaused = true
                self.isRunning = false
            }
        }
        #endif
    }
    
    func resumeWorkout() {
        #if os(watchOS)
        guard let session = session else { return }

        if session.state == .paused {
            session.resume()
            // Calculate accumulated pause time
            if let pauseDate = pauseDate {
                accumulatedTime += Date().timeIntervalSince(pauseDate)
            }
            pauseDate = nil
            
            // Restart the timer
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.updateTotalTime()
            }
            
            DispatchQueue.main.async {
                print("Session resumed on Queue")
                self.isPaused = false
                self.isRunning = true
            }
        }
        #endif
    }
    
    private func updateTotalTime() {
        guard let startDate = session?.startDate else { return }
        let elapsed = Date().timeIntervalSince(startDate)
        DispatchQueue.main.async {
            self.totalTime = elapsed - self.accumulatedTime
        }
    }

    func resetWorkout() {
        #if os(watchOS)
        builder = nil
        session = nil
        activeEnergy = 0
        averageHeartRate = 0
        heartRate = 0
        distance = 0
        
        #endif
    }
    
    
    
    func endWorkout(_ workoutType: String) {
        #if os(watchOS)
        guard let session = session, let builder = builder else { return }

        // First, end the session
        session.end()
        timer?.invalidate()
        timer = nil
        dataSendTimer?.invalidate()
        dataSendTimer = nil
        pauseDate = nil
        accumulatedTime = 0

        // Then, end the data collection
        builder.endCollection(withEnd: Date()) { success, error in
            print("Here")
            if success {
                // Finalize the workout
                self.builder?.finishWorkout(completion: { (workout, error) in
                    if let error = error {
                        print("Error finishing workout: \(error.localizedDescription)")
                    } else {
                        DispatchQueue.main.async {
                            self.isWorkoutInProgress = false
                        }
                        print("Workout successfully finished!")
                    }
                    
                    guard let workout = workout else {
                        print("No workout generated")
                        return
                    }
                    
                    self.saveWorkoutToHealthStore(workout: workout, workoutType)
                })
            } else if let error = error {
                print("Error ending workout collection: \(error.localizedDescription)")
            }
        }
        // Update iPhone app
        self.sendWorkoutEndedMessage()
        showingSummaryView = true
        print("showingSummaryView set to \(showingSummaryView)")
        #endif
    }
    @Published var averageHeartRate: Double = 0
    @Published var heartRate: Double = 0
    @Published var activeEnergy: Double = 0
    @Published var distance2: Double = 0
    func updateForStatistics(_ statistics: HKStatistics?) {
        guard let statistics = statistics else { return }

        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
                self.heartRate = statistics.mostRecentQuantity()?.doubleValue(for: heartRateUnit) ?? 0
                self.averageHeartRate = statistics.averageQuantity()?.doubleValue(for: heartRateUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                let energyUnit = HKUnit.kilocalorie()
                self.activeEnergy = statistics.sumQuantity()?.doubleValue(for: energyUnit) ?? 0
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning), HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                let meterUnit = HKUnit.meter()
                self.distance = statistics.sumQuantity()?.doubleValue(for: meterUnit) ?? 0
            default:
                return
            }
        }
    }
    
    func saveWorkoutToHealthStore(workout: HKWorkout, _ workoutType: String) {
        var samples: [HKSample] = []

        // Create the distance sample
        let distanceQuantity = HKQuantity(unit: HKUnit.mile(), doubleValue: distance)
        let distanceSample = HKQuantitySample(
            type: WorkoutType(workoutType.lowercased()).getQuantityType(),
            quantity: distanceQuantity,
            start: workout.startDate,
            end: workout.endDate
        )
        samples.append(distanceSample)
        
        // Create the energy sample
        let energyQuantity = HKQuantity(unit: HKUnit.kilocalorie(), doubleValue: calories)
        let energySample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            quantity: energyQuantity,
            start: workout.startDate,
            end: workout.endDate
        )
        samples.append(energySample)
        
        // Heart rate series data
        if !heartRatePoints.isEmpty {
            let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!
            let heartRateSamples = heartRatePoints.map { (date, value) in
                HKQuantitySample(
                    type: heartRateType,
                    quantity: HKQuantity(unit: HKUnit.count().unitDivided(by: .minute()), doubleValue: value),
                    start: date,
                    end: date.addingTimeInterval(1) // 1 second duration for instant measurement
                )
            }
            
            // Add average heart rate sample
            let totalHeartRate = heartRatePoints.reduce(0.0) { $0 + $1.1 }
            let averageHeartRate = totalHeartRate / Double(heartRatePoints.count)
            let heartRateQuantity = HKQuantity(unit: HKUnit.count().unitDivided(by: .minute()), doubleValue: averageHeartRate)
            
            let averageHeartRateSample = HKQuantitySample(
                type: heartRateType,
                quantity: heartRateQuantity,
                start: workout.startDate,
                end: workout.endDate
            )
            
            samples.append(contentsOf: heartRateSamples)
            samples.append(averageHeartRateSample)
        }
        
        // Route data
        // Fix: More robust route saving
        if !routePoints.isEmpty {
            let routeBuilder = HKWorkoutRouteBuilder(healthStore: healthStore, device: .local())
            
            // Save route data in batches to ensure all points are captured
            let locations = routePoints.map { location in
                // Include timestamp and other metadata
                return CLLocation(
                    coordinate: location.coordinate,
                    altitude: location.altitude,
                    horizontalAccuracy: location.horizontalAccuracy,
                    verticalAccuracy: location.verticalAccuracy,
                    timestamp: location.timestamp
                )
            }
            
            routeBuilder.insertRouteData(locations) { success, error in
                if success {
                    routeBuilder.finishRoute(with: workout, metadata: nil) { route, error in
                        if let route = route {
                            samples.append(route)
                        }
                    }
                } else if let error = error {
                    print("Error inserting route data: \(error.localizedDescription)")
                }
            }
        }
        
        // Add average pace sample
        if let paceType = HKQuantityType.quantityType(forIdentifier: .runningSpeed) {
            let averagePace = distance / (totalTime / 60)
            let paceQuantity = HKQuantity(unit: HKUnit.mile().unitDivided(by: HKUnit.second()),
                                  doubleValue: averagePace)
                        
            let paceSample = HKQuantitySample(
                type: paceType,
                quantity: paceQuantity,
                start: workout.startDate,
                end: workout.endDate
            )
            samples.append(paceSample)
        }

        // Save the workout and associated samples to HealthKit
        samples.append(workout)
        healthStore.save(samples) { (success, error) in
            if let error = error {
                print("Error saving workout to HealthKit: \(error.localizedDescription)")
            } else {
                print("Workout successfully saved to HealthKit")
            }
        }
    }
}

#if os(watchOS)
extension WorkoutManager: HKWorkoutSessionDelegate, HKLiveWorkoutBuilderDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState, from fromState: HKWorkoutSessionState, date: Date) {
        #if os(watchOS)
        if toState == .ended {
            builder?.endCollection(withEnd: date, completion: { (success, error) in
                self.builder?.finishWorkout(completion: { (workout, error) in
                    DispatchQueue.main.async {
                        self.isPaused = false
                        self.isRunning = false
                        print("Successfully ended workout")
                    }
                })
            })
        }
        #endif
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {
        #if os(watchOS)
        print("Workout session failed: \(error.localizedDescription)")
        #endif
    }

    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {
        // handles workout events if needed
    }
    
    func sendWorkoutData() {
    if WCSession.default.isReachable {
        
        let workoutData: [String: Any] = [
            "currentDistance": self.distance2,
            "currentCalories": self.activeEnergy,
            "currentHeartRate": self.heartRate,
            "currentPace": self.distance2 / (totalTime / 60),
            "totalTime": totalTime
        ]
        WCSession.default.sendMessage(workoutData, replyHandler: nil, errorHandler: { error in
            print("Error sending workout data: \(error.localizedDescription)")
        })
    } else {
        print("Session is not reachable")
    }
}

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        #if os(watchOS)
        // Handle collected data if needed
        for type in collectedTypes {
            if let quantityType = type as? HKQuantityType {
                
                // Track distance traveled for running
                if quantityType == HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) ||
                    quantityType == HKObjectType.quantityType(forIdentifier: .distanceCycling) ||
                    quantityType == HKObjectType.quantityType(forIdentifier: .distanceSwimming) {
                    if let distance = workoutBuilder.statistics(for: quantityType)?.sumQuantity() {
                        DispatchQueue.main.sync {
                            let distanceInMiles = distance.doubleValue(for: HKUnit.mile())
                            print("Distance: \(distanceInMiles) miles")
                            self.distance = distanceInMiles
                            self.sendWorkoutData()
                        }
                    }
                }
                
                // Track active calories burned
                if quantityType == HKObjectType.quantityType(forIdentifier: .activeEnergyBurned) {
                    if let calories = workoutBuilder.statistics(for: quantityType)?.sumQuantity() {
                        DispatchQueue.main.sync {
                            let caloriesInKilocalories = calories.doubleValue(for: HKUnit.kilocalorie())
                            print("Calories Burned: \(caloriesInKilocalories) kcal")
                            self.calories = caloriesInKilocalories
                            self.sendWorkoutData()
                        }
                        
                    }
                }
                
                // Track heart rate
                if quantityType == HKObjectType.quantityType(forIdentifier: .heartRate) {
                    let heartRateUnit = HKUnit.count().unitDivided(by: .minute())
                    
                    // Get the statistics for heart rate
                    if let statistics = workoutBuilder.statistics(for: quantityType),
                       let heartRate = statistics.mostRecentQuantity() {
                        let heartRateValue = heartRate.doubleValue(for: heartRateUnit)
                        let timestamp = statistics.mostRecentQuantityDateInterval()?.start ?? Date()
                        
                        DispatchQueue.main.async {
                            self.heartRate = heartRateValue
                            // Add point to heart rate chart data
                            self.heartRatePoints.append((timestamp, heartRateValue))
                            self.sendWorkoutData()
                        }
                    }
                }
            }
        }
        #endif
    }
}

// Location manager delegate for map tracking
extension WorkoutManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.routePoints.append(location)
        }
    }
}
#endif
