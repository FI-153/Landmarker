//
//  LocationManager.swift
//  Landmarker
//
//  Created by Federico Imberti on 27/12/21.
//

import Foundation
import MapKit
import SwiftUI

class LocationsManager: ObservableObject {
    ///All stored locations
    @Published var locations:[Location]

    ///Current location on the map, when set the map shown is changed accordingly
    @Published var mapLocation:Location {
        didSet{
            updateMapRegion(location: mapLocation)
        }
    }
    
    ///Diplayed region on the map
    @Published var mapRegion:MKCoordinateRegion = MKCoordinateRegion()

    init(){
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        
        self.updateMapRegion(location: mapLocation)
    }

    
    ///Updates what the map is showing
    private func updateMapRegion(location:Location){
        withAnimation(.easeInOut){
            mapRegion = MKCoordinateRegion(center: location.coordinates,
                                      span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007))
        }
    }

    ///Shows a specifica location
    func showLocation(location:Location){
        withAnimation(.easeInOut){
            mapLocation = location
        }
    }
    
    ///Gets the next location saved
    func getNextLocation() -> Location{
        
        //If the last location has been reached go back to the beginning
        if mapLocation == locations.last {
            return locations[0]
        }
        
        let nextLocation = locations.firstIndex(of: mapLocation)! + 1
        return locations[nextLocation]
        
    }
    
    ///Shown the next location
    func showNextLocation(){
        showLocation(location: getNextLocation())
    }
    
    ///Prompts directions to a specified location
    static func getDirections(to location:Location) {
        let latitude = location.coordinates.latitude
        let longitude = location.coordinates.longitude
        
        if let url = URL(string: "maps://?daddr=\(latitude),\(longitude)&dirflg=w") {
            if UIApplication.shared.canOpenURL(url){
                //Opens the Maps app with directions to the desired landmark from the current position
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }

}
