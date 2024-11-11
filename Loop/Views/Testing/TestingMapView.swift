//  TestingView.swift
//  Loop
//
//  Created by Amiire Kolawole on 2024-11-10.
//

import SwiftUI
import CoreLocation
import MapKit

struct MapView: UIViewRepresentable {
    let routePoints: [CLLocation]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.preferredConfiguration = {
            let config = MKStandardMapConfiguration()
            config.pointOfInterestFilter = .excludingAll
            config.emphasisStyle = .muted
            return config
        }()
        mapView.addOverlay(
            MKPolyline(coordinates: routePoints.map { $0.coordinate },
                       count: routePoints.count))
        mapView.setRegion(regionForCoordinates(routePoints.map { $0.coordinate }),
                          animated: false)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {}
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    private func regionForCoordinates(_ coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        let minLat = coordinates.map(\.latitude).min() ?? 0
        let maxLat = coordinates.map(\.latitude).max() ?? 0
        let minLon = coordinates.map(\.longitude).min() ?? 0
        let maxLon = coordinates.map(\.longitude).max() ?? 0
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: (minLat + maxLat) / 2,
                longitude: (minLon + maxLon) / 2),
            span: MKCoordinateSpan(
                latitudeDelta: (maxLat - minLat) * 1.5,
                longitudeDelta: (maxLon - minLon) * 1.5)
        )
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else { return MKOverlayRenderer(overlay: overlay) }
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .yellow
            renderer.lineWidth = 3
            return renderer
        }
    }
}

struct TestingMapView: View {
    let routePoints: [CLLocation] = [
        CLLocation(latitude: 37.7749, longitude: -122.4194),
        CLLocation(latitude: 37.7847, longitude: -122.4141),
        CLLocation(latitude: 37.7946, longitude: -122.4110),
        CLLocation(latitude: 37.8014, longitude: -122.4163),
        CLLocation(latitude: 37.8061, longitude: -122.4196),
    ]
    
    var body: some View {
        MapView(routePoints: routePoints)
            .preferredColorScheme(.dark)
    }
}

#Preview {
    TestingMapView()
}
