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
    
    ///Publishes all downloaded locations
    @Published var downloadedData:[Landmark] = []
    
    ///Controls the loading view
    @Published var isLoading = true

    ///Singleton instance of the class
    static let shared = DownloadDataManager()
    private init(){
		
		Task{
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
			
			URLSession.shared.dataTaskPublisher(for: try buildUrl())
				.receive(on: DispatchQueue.main)
				.tryMap(handleOutput)
				.decode(type: [Landmark].self, decoder: JSONDecoder())
				.replaceError(with: Landmark.mockLandmarks)
				.sink { [weak self] returnedLocations in
					
					guard let self = self else { return }
					
					self.downloadImages(for: returnedLocations)
					self.setDownloadedData(to: returnedLocations)
					self.dismissLoadingView()
					
				}
				.store(in: &cancellables)
			
		} catch let error {
			print(error)
		}
	}
	
	private func buildUrl() throws -> URL {
		guard let url = URL(string: "https://raw.githubusercontent.com/FI-153/LandmarkerBackend/f32c6e8d5115b8759f0a93aed1d044c685b20bd4/JSON/landmarkData.json") else {
			throw URLError(.badURL)
		}
		
		return url
	}
	
	private func setDownloadedData(to locations: [Landmark]) {
		self.downloadedData = locations
	}
	
	private func downloadImages(for locations: [Landmark]) {
		let downloadImagesManager = DownloadImagesManager.shared
		
		downloadImagesManager.downloadThumbails(for: locations)
		downloadImagesManager.downloadImages(for: locations)
	}
	
    private func handleOutput(output:URLSession.DataTaskPublisher.Output) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
                throw URLError(.badServerResponse)
            }
        return output.data
    }
	
	private func dismissLoadingView() {
		isLoading = false
	}

}
