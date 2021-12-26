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
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let camera = MKMapCamera(lookingAtCenter: coordinate,
                                 fromDistance: 1200,
                                 pitch: is3DEnabled ? 80 : 0,
                                 heading: 0)
        uiView.setCamera(camera, animated: true)
    }
}
