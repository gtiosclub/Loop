//
//  Map.swift
//  Loop
//
//  Created by Jihoon Kim on 10/28/24.
//

import Foundation
import MapKit
import CoreLocation
import UIKit
import os

class MapViewController: UIViewController {
    var nodes: Path!
    var pathRenderer: PathRenderer?
    
    var breadcrumbBoundingPolygon: MKPolygon?
    
    let locationManager = CLLocationManager()
    
    var isMonitoringLocation = false
    
}

class Path: NSObject, MKOverlay {
    private struct PathData {
        var locations: [CLLocation]
        
        var bounds: MKMapRect
        
        init(locations: [CLLocation] = [CLLocation](), pathBounds: MKMapRect = MKMapRect.world) {
            self.locations = locations
            self.bounds = pathBounds
        }
    }
    
    let boundingMapRect = MKMapRect.world
    private(set) var coordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    private let protectedBreadcrumbData = OSAllocatedUnfairLock(initialState: PathData())
    
    var pathBounds: MKMapRect {
        return protectedBreadcrumbData.withLock { breadcrumbData in
            return breadcrumbData.bounds
        }
    }
    
    var locations: [CLLocation] {
        return protectedBreadcrumbData.withLock { breadcrumbData in
            return breadcrumbData.locations
        }
    }
    
    func addLocation(_ newLocation: CLLocation) -> (locationAdded: Bool, boundingRectChanged: Bool) {
        let result = protectedBreadcrumbData.withLock { pathData in
            guard isNewLocationUsable(newLocation, PathData: pathData) else {
                let locationChanged = false
                let boundsChanged = false
                return (locationChanged, boundsChanged)
            }
            
            var previousLocation = pathData.locations.last
            if pathData.locations.isEmpty {
                coordinate = newLocation.coordinate
                let origin = MKMapPoint(coordinate)
                let oneKilometerInMapPoints = 1000 * MKMapPointsPerMeterAtLatitude(coordinate.latitude)
                let oneSquareKilometer = MKMapSize(width: oneKilometerInMapPoints, height: oneKilometerInMapPoints)
                pathData.bounds = MKMapRect(origin: origin, size: oneSquareKilometer)
                pathData.bounds = pathData.bounds.intersection(.world)
                previousLocation = newLocation
            }
            
            pathData.locations.append(newLocation)

            let pointSize = MKMapSize(width: 0, height: 0)
            let newPointRect = MKMapRect(origin: MKMapPoint(newLocation.coordinate), size: pointSize)
            let prevPointRect = MKMapRect(origin: MKMapPoint(previousLocation!.coordinate), size: pointSize)
            let pointRect = newPointRect.union(prevPointRect)
            
            var boundsChanged = false
            let locationChanged = true
            if !pathData.bounds.contains(pointRect) {
                var grownBounds = pathData.bounds.union(pointRect)
                let paddingAmountInMapPoints = 1000 * MKMapPointsPerMeterAtLatitude(pointRect.origin.coordinate.latitude)
                if pointRect.minY < pathData.bounds.minY {
                    grownBounds.origin.y -= paddingAmountInMapPoints
                    grownBounds.size.height += paddingAmountInMapPoints
                }
                if pointRect.maxY > pathData.bounds.maxY {
                    grownBounds.size.height += paddingAmountInMapPoints
                }
                if pointRect.minX < pathData.bounds.minX {
                    grownBounds.origin.x -= paddingAmountInMapPoints
                    grownBounds.size.width += paddingAmountInMapPoints
                }
                if pointRect.maxX > pathData.bounds.maxX {
                    grownBounds.size.width += paddingAmountInMapPoints
                }
                pathData.bounds = grownBounds.intersection(.world)
                boundsChanged = true
            }
            
            return (locationChanged, boundsChanged)
        }
        return result
    }
    
    private func isNewLocationUsable(_ newLocation: CLLocation, PathData: PathData) -> Bool {
        let now = Date()
        let locationAge = now.timeIntervalSince(newLocation.timestamp)
        guard locationAge < 60 else { return false }
        
        guard PathData.locations.count > 10 else { return true }
        
        let minimumDistanceBetweenLocationsInMeters = 10.0
        let previousLocation = PathData.locations.last!
        let metersApart = newLocation.distance(from: previousLocation)
        return metersApart > minimumDistanceBetweenLocationsInMeters
    }
}

class PathRenderer: MKOverlayRenderer {
    private let nodes: Path
    
    init(nodePath: Path) {
        nodes = nodePath
        super.init(overlay: nodePath)
    }
    
    override func canDraw(_ mapRect: MKMapRect, zoomScale: MKZoomScale) -> Bool {
        return nodes.pathBounds.intersects(mapRect)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        let lineWidth = MKRoadWidthAtZoomScale(zoomScale)
        
        let clipRect = mapRect.insetBy(dx: -lineWidth, dy: -lineWidth)
        
        let points = nodes.locations.map { MKMapPoint($0.coordinate) }
        if let path = pathForPoints(points, mapRect: clipRect, zoomScale: zoomScale) {
            context.addPath(path)
            context.setStrokeColor(UIColor.systemBlue.withAlphaComponent(0.5).cgColor)
            context.setLineJoin(.round)
            context.setLineCap(.round)
            context.setLineWidth(lineWidth)
            context.strokePath()
        }
    }
    
    private func lineBetween(points: (p0: MKMapPoint, p1: MKMapPoint), intersects rect: MKMapRect) -> Bool {
        let minX = Double.minimum(points.p0.x, points.p1.x)
        let minY = Double.minimum(points.p0.y, points.p1.y)
        let maxX = Double.maximum(points.p0.x, points.p1.x)
        let maxY = Double.maximum(points.p0.y, points.p1.y)
        
        let testRect = MKMapRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        return rect.intersects(testRect)
    }
    
    private func addLine(to path: CGMutablePath, with points: (p0: MKMapPoint, p1: MKMapPoint), liftingPen: Bool) {
        if liftingPen {
            let lastDrawingPoint = self.point(for: points.p1)
            path.move(to: lastDrawingPoint)
        }
        let drawingPoint = self.point(for: points.p0)
        path.addLine(to: drawingPoint)
    }
    
    private func pathForPoints(_ points: [MKMapPoint], mapRect: MKMapRect, zoomScale: MKZoomScale) -> CGPath? {
        guard points.count > 1 else { return nil }
        
        let path = CGMutablePath()
        
        var needsToLiftPen = true
        
        let minimumScreenPoints = 5.0
        let minPointDelta = minimumScreenPoints / zoomScale
        let cSquared = pow(minPointDelta, 2)
        
        var lastMapPoint = points.first!
        for (index, mapPoint) in points.enumerated() {
            if index == 0 { continue }
            
            let aSquaredBSquared = pow(mapPoint.x - lastMapPoint.x, 2) + pow(mapPoint.y - lastMapPoint.y, 2)
            if aSquaredBSquared >= cSquared {
                if lineBetween(points: (mapPoint, lastMapPoint), intersects: mapRect) {
                    addLine(to: path, with: (mapPoint, lastMapPoint), liftingPen: needsToLiftPen)
                    needsToLiftPen = false
                } else {
                    needsToLiftPen = true
                }
                lastMapPoint = mapPoint
            }
        }
        
        let mapPoint = points.last!
        if lineBetween(points: (mapPoint, lastMapPoint), intersects: mapRect) {
            addLine(to: path, with: (mapPoint, lastMapPoint), liftingPen: needsToLiftPen)
        }
        
        return path
    }
    
    
}
