//
//  LocationsDataService.swift
//  MapTest
//
//  Created by Nick Sarno on 11/26/21.
//

import Foundation
import MapKit
import Combine

class DownloadDataManager {
    
    @Published var downloadedData:[Location] = []
    @Published var isLoading = true

    ///Singleton instance of the class
    static let shared = DownloadDataManager()
    private init(){
        do {
            try getLandmarksData()
        }catch let error {
            print(error)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    ///Downloads the landmarks from  API
    private func getLandmarksData() throws{
        guard let url = URL(string: "https://raw.githubusercontent.com/FI-153/Landmarker/imagesDownloading/Backend/landmarkData.json?token=GHSAT0AAAAAABO2LV7MTYIPIVSLCKJL3ZPSYPBZ3BQ") else {
            throw URLError(.badURL)
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: [Location].self, decoder: JSONDecoder())
            .replaceError(with: DownloadDataManager.mockLocations)
            .sink { [weak self] returnedLocations in
                guard let self = self else { return }
                self.downloadedData = returnedLocations
                self.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    ///Handles the output from the downloader
    private func handleOutput(output:URLSession.DataTaskPublisher.Output) throws -> Data {
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
