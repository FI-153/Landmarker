//
//  LocationManager.swift
//  Landmarker
//
//  Created by Federico Imberti on 27/12/21.
//

import Foundation
import MapKit
import SwiftUI
import Combine

class LocationsManager: ObservableObject {
    ///All stored locations
    @Published var locations:[Landmark]

    ///Current location on the map. When set, the map is changed to center on this Landmark
    @Published var mapLocation:Landmark {
        didSet{
            updateMapRegion(to: mapLocation)
        }
    }
    
    ///Diplayed region on the map
    @Published var mapRegion:MKCoordinateRegion = MKCoordinateRegion()

    init(){
        self.locations = []
        
        self.mapLocation = Landmark.getFirstMockLocation()
        
        addSubscriberToLocations_getsDownloadedLocations()
        addSubscriberToMapLocation_selectsTheFirstLocation()
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let downloadDataManager = DownloadDataManager.getShared()
    
	private func addSubscriberToLocations_getsDownloadedLocations(){
        downloadDataManager
            .$downloadedData
            .sink { [weak self] downloadedData in
                guard let self = self else { return }
				
                self.setLocations(to: downloadedData)
            }
            .store(in: &cancellables)
    }
	
	private func setLocations(to locations:[Landmark]) {
		self.locations = locations
	}
	
	private func addSubscriberToMapLocation_selectsTheFirstLocation(){
        downloadDataManager
            .$downloadedData
            .map({ (downloadedLocations: [Landmark]) -> Landmark in
                if let firstLocation = downloadedLocations.first {
                    return firstLocation
                } else {
                    return Landmark.getFirstMockLocation()
                }
            })
            .sink { [weak self] firstLocation in
                
                guard let self = self else { return }
                self.setMapLocation(to: firstLocation)
            }
            .store(in: &cancellables)
    }

	private func setMapLocation(to location:Landmark) {
		self.mapLocation = location
	}

    ///Updates what the map is showing
	private func updateMapRegion(to location:Landmark){
        withAnimation(.easeInOut){
            mapRegion = MKCoordinateRegion(
				center: location.coordinates,
				span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
			)
        }
    }

    ///Shows a specifica location
    func showLocation(_ location:Landmark){
        withAnimation(.easeInOut){
            mapLocation = location
        }
    }
    
    ///Gets the next location saved
	private func getNextLocation() -> Landmark{
        // TODO set as circular array
        
        //If the last location has been reached go back to the beginning
        if mapLocation == locations.last {
            return locations[0]
        }
        
        let nextLocation = locations.firstIndex(of: mapLocation)! + 1
        return locations[nextLocation]
        
    }
    
    ///Shown the next location
    func showNextLocation(){
        showLocation(getNextLocation())
    }
    
    ///Prompts directions to a specified location
    static func getDirections(to location:Landmark) {
        let latitude = location.coordinates.latitude
        let longitude = location.coordinates.longitude
        
        if let url = URL(string: "maps://?daddr=\(latitude),\(longitude)&dirflg=w") {
            if UIApplication.shared.canOpenURL(url){
                openMapsApp(to: url)
            }
        }
    }
	
	static private func openMapsApp(to location: URL){
		UIApplication.shared.open(location, options: [:], completionHandler: nil)
	}

}
