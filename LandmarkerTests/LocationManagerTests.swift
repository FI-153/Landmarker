//
//  LandmarkerTests.swift
//  LandmarkerTests
//
//  Created by Federico Imberti on 28/12/21.
//

import XCTest
import MapKit
@testable import Landmarker

class LocationManagerTests: XCTestCase {
    
    let locationManager = LocationsManager()
    let locations = LocationsDataService.locations

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test_LocationManager_updateMapRegion_theMapRegionIsUpdated_stress(){
        
        for location in locations {
            //Given
            let finalRegion = MKCoordinateRegion(center: location.coordinates,
                                                 span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007))
            
            //When
            locationManager.updateMapRegion(to: location)
            
            //Then
            XCTAssertEqual(locationManager.mapRegion.center.longitude, finalRegion.center.longitude)
            XCTAssertEqual(locationManager.mapRegion.center.latitude, finalRegion.center.latitude)
        }
        
    }
    
    func test_LocationManager_showLocation_theLocationIsShown_stress(){
        
        for location in locations {
            //Given
            //When
            locationManager.showLocation(location: location)
            
            //Then
            XCTAssertEqual(locationManager.mapLocation, location)
        }
        
    }
    
    func test_LocationManager_getNextLocation_theNextLocationisPresented(){
        
        for _ in 1...10 {
            
            //Given
            if var currentLocationIndexPlusOne = locations.firstIndex(of: locationManager.mapLocation) {
                currentLocationIndexPlusOne = currentLocationIndexPlusOne + 1
                //When
                let nextLocation = locationManager.getNextLocation()
                let nextLocationIndex = locations.firstIndex(of: nextLocation)
                
                //Then
                XCTAssertEqual(currentLocationIndexPlusOne, nextLocationIndex)
            } else {
                XCTFail()
            }
            
        }
    }
    
    func test_LocationManager_mapLocation_didSet_theMapRegionChangesWhenTheMapLocationIsChanged(){
        //Given
        let location = locations[2]
        
        //When
        locationManager.mapLocation = location
        
        //Then
        XCTAssertEqual(locationManager.mapRegion.center.latitude, location.coordinates.latitude)
        XCTAssertEqual(locationManager.mapRegion.center.longitude, location.coordinates.longitude)

    }
    
}
