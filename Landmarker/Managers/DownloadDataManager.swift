//
//  LocationsDataService.swift
//  MapTest
//
//  Created by Nick Sarno on 11/26/21.
//

import Foundation
import Combine

class DownloadDataManager {
    
    /// Downloaded locations
    @Published var downloadedData:[Landmark] = []
    
    /// True if the location's download is over otherwise it's false
    @Published var isLoading = true

    /// Singleton instance of the class
    private static let shared = DownloadDataManager()
    static func getShared() -> DownloadDataManager {
        return shared;
    }
    private init(){
		Task(priority: .high){
			do {
				try await getLandmarksData()
			}catch let error {
				print(error)
			}
		}
	}
	
    private var cancellables = Set<AnyCancellable>()
    
    ///Downloads the landmarks from  API
	private func getLandmarksData() async throws{
		do {
			URLSession
                .shared
                .dataTaskPublisher(for: try buildUrl())
				.receive(on: DispatchQueue.main)
				.tryMap(handleOutput)
				.decode(type: [Landmark].self, decoder: JSONDecoder())
				.replaceError(with: Landmark.mockLandmarks)
				.sink { [weak self] returnedLocations in
					
					guard let self = self else { return }
					
					self.downloadImages(for: returnedLocations)
					self.saveDownloadedData(to: returnedLocations)
					self.dismissLoadingView()
					
				}
				.store(in: &cancellables)
			
		} catch let error {
			print(error)
		}
	}
	
    /// Checks if the given url is valid
    /// - Returns: The URL if it's valid, otherwise it throws and error
	private func buildUrl() throws -> URL {
		guard let url = URL(string: "https://raw.githubusercontent.com/FI-153/LandmarkerBackend/f32c6e8d5115b8759f0a93aed1d044c685b20bd4/JSON/landmarkData.json") else {
			throw URLError(.badURL)
		}
		
		return url
	}
    
    /// Saves the downloaded data
    /// - Parameter locations: Landamrks to save
	private func saveDownloadedData(to locations: [Landmark]) {
		self.downloadedData = locations
	}
    
    /// Downloads the thumbnail and images for the given Landmarks
    /// - Parameter locations: Landmarks for which to download images
	private func downloadImages(for locations: [Landmark]) {
		
		let downloadImagesManager = DownloadImagesManager.getShared()
		
		Task(priority: .high) {
			await downloadImagesManager.downloadThumbails(for: locations)
		}
		
		Task(priority: .low){
			await downloadImagesManager.downloadImages(for: locations)
		}
	}
	
    
    /// Checks if the downloaded data are correct by checking the HTTP response code
    /// - Returns: The output data if the response is correct
	private func handleOutput(output:URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300
        else {
            throw URLError(.badServerResponse)
        }
        
        return output.data
    }
	
	private func dismissLoadingView() {
		isLoading = false
	}

}
