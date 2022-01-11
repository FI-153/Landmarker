//
//  MapView.swift
//  Landmarker
//
//  Created by Federico Imberti on 26/12/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let location:Location
    let is3DEnabled:Bool
    let centerImage:Bool
    let locationsDataService = DownloadDataManager.shared
    
    var mapView = MKMapView(frame: .zero)
        
    func makeUIView(context: Context) -> MKMapView {
        mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let camera = MKMapCamera(lookingAtCenter: centerImage ? location.coordinates : location.coordinates,
                                 fromDistance: location.optimalDistance,
                                 pitch: is3DEnabled ? location.optimalPitch : 0,
                                 heading: location.optimalHeading)
        
        uiView.setCamera(camera, animated: true)
    }
}
