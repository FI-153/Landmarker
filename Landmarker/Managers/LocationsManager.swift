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
    @Published var locations:[Location]

    ///Current location on the map, when set the map shown is changed accordingly
    @Published var mapLocation:Location {
        didSet{
            updateMapRegion(to: mapLocation)
        }
    }
    
    ///Diplayed region on the map
    @Published var mapRegion:MKCoordinateRegion = MKCoordinateRegion()
    
    var cancellables = Set<AnyCancellable>()

    init(){
        self.locations = []
        self.mapLocation = LocationsDataService.mockLocations[0]
        
        do{
            try self.getLandmarks()
        }catch let error {
            print(error)
        }
    }
    
    ///Downloads the landmarks from  API
    func getLandmarks() throws{
        guard let url = URL(string: "https://api.npoint.io/6fc0a73b89a6dd862f90") else {
            throw URLError(.badURL)
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: [Location].self, decoder: JSONDecoder())
            .replaceError(with: LocationsDataService.mockLocations)
            .sink { [weak self] returnedLocations in
                self?.locations = returnedLocations
                self?.mapLocation = returnedLocations[0]
            }
            .store(in: &cancellables)
    }
    
    func handleOutput(output:URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                throw URLError(.badServerResponse)
            }
        return output.data
    }

    
    ///Updates what the map is showing
    func updateMapRegion(to location:Location){
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
