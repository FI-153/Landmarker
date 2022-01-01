//
//  LocationsDataService.swift
//  MapTest
//
//  Created by Nick Sarno on 11/26/21.
//

import Foundation
import MapKit

class LocationsDataService {
    
    static let shared = LocationsDataService()
        
    static let mockLocations: [Location] = [
        Location(
            name: "Mock",
            cityName: "mockCity",
            coordinates: CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922),
            description: ".",
            imageNames: [
                "",
                "",
                "",
            ],
            link: "",
            optimalDistance: 1200,
            optimalPitch: 80,
            optimalHeading: 0)
    ]
    
}
