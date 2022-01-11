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
        guard let url = URL(string: "https://raw.githubusercontent.com/FI-153/LandmarkerBackend/main/JSON/landmarkData.json?token=GHSAT0AAAAAABO2LV7NCDAO4MR3KUCVF3VOYPB2S6Q") else {
            throw URLError(.badURL)
        }
        
        let downloadImagesManager = DownloadImagesManager.shared
        
        URLSession.shared.dataTaskPublisher(for: url)
            .receive(on: DispatchQueue.main)
            .tryMap(handleOutput)
            .decode(type: [Location].self, decoder: JSONDecoder())
            .replaceError(with: Location.mockLocations)
            .sink { [weak self] returnedLocations in
                guard let self = self else { return }
                
                self.downloadedData = returnedLocations
                
                downloadImagesManager.downloadThumbails(for: returnedLocations)
                
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
    
}
