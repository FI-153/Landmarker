//
//  MapView.swift
//  Landmarker
//
//  Created by Federico Imberti on 26/12/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let coordinate:CLLocationCoordinate2D
    let is3DEnabled:Bool
    
    var mapView = MKMapView(frame: .zero)
    
    func makeUIView(context: Context) -> MKMapView {
        mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let camera = MKMapCamera(lookingAtCenter: coordinate,
                                 fromDistance: 1200,
                                 pitch: is3DEnabled ? 80 : 0,
                                 heading: 0)
        
        uiView.setCamera(camera, animated: true)
        
        placePins()
    }
    
    func placePins() {
        let locations = LocationsDataService.locations
        
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinates
            annotation.title = location.name
            
            mapView.addAnnotation(annotation)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        annotationView.markerTintColor = UIColor.blue
        return annotationView
    }
}
