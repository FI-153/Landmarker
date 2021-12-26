//
//  LocationViewModel.swift
//  Landmarker
//
//  Created by Federico Imberti on 25/12/21.
//

import Foundation
import MapKit
import SwiftUI

class LocationsViewModel: ObservableObject {
    
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
    
    @Published var isLocationListShown = false
    
    @Published var is3DShown = true
    
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
    
    ///Toggles the activation of the drop-down menu to select locations
     func toggleLocationsList(){
        withAnimation(.spring()){
            self.isLocationListShown.toggle()
        }
    }
    
    ///Shows a specifica location
    func showNextLocation(location:Location){
        withAnimation(.easeInOut){
            mapLocation = location
            isLocationListShown = false
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

    
}
