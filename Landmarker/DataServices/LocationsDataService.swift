//
//  LocationsDataService.swift
//  MapTest
//
//  Created by Nick Sarno on 11/26/21.
//

import Foundation
import MapKit
import Combine

class LocationsDataService {
    
    @Published var downloadedData:[Location] = []

    ///Singleton instance of the class
    static let shared = LocationsDataService()
    private init(){
        do {
            try getLandmarks()
        }catch let error {
            print(error)
        }
    }
    
    var cancellables = Set<AnyCancellable>()
    
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
                self?.downloadedData = returnedLocations
            }
            .store(in: &cancellables)
    }
    
    ///Handles the output from the downloader
    func handleOutput(output:URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                throw URLError(.badServerResponse)
            }
        return output.data
    }
    
    ///Mock data to be used during development
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
