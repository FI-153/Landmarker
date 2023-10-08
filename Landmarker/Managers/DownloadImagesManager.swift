//
//  DownloadImagesManager.swift
//  Landmarker
//
//  Created by Federico Imberti on 08/01/22.
//

import Foundation
import Combine
import UIKit

class DownloadImagesManager:ObservableObject {
    
    ///Singleton instance of the DownloadImagesManager
    private static let shared = DownloadImagesManager()
    /// Gets the shared instance of DownloadImagesManager
    static func getShared() -> DownloadImagesManager {
        return shared;
    }
    private init(){}
    
    var cancellables = Set<AnyCancellable>()
        
    ///All the downloaded images identified by the Location's id
    @Published var downloadedImages:[String: UIImage] = [:]
    
    /// Downloads all the images for the given Landmarks, except for the thumbnails
    /// - Parameter locations: Array of Landmarks for which to download the images
	func downloadImages(for locations: [Landmark]) async {
		do {
			for location in locations {
				try location.imageNames.forEach {
					URLSession
                        .shared
                        .dataTaskPublisher(for: try buildUrl(for: $0))
						.map { UIImage(data: $0.data) }
						.receive(on: DispatchQueue.main)
						.sink { _ in
						} receiveValue: { [weak self] downloadedImage in
							guard let self = self else { return }
							
							if let validDownloadedImage = downloadedImage {
								self.appendDownloadedImages(for: self.generateKey(for: location), value: validDownloadedImage)
							}
						}
						.store(in: &cancellables)
				}
			}
		} catch let error {
			print(error)
		}
	}
	
    
    /// Builds the URL based on the URL string in the downlaoded object
    /// - Parameter locationImageUrl: URL string
    /// - Returns: The URL when it's possible to build it, otherwise it throws an error
	private func buildUrl(for locationImageUrl: String) throws -> URL {
		guard let url = URL(string: locationImageUrl) else {
			throw URLError(.badURL)
		}
		return url
	}
	
    
    /// Generates a unique key for each of the downlaoded images for a given landmark.
    /// The image's id is the same as the landmark + a new UUID
    /// - Parameter location: Landmark for which to generate a key
    /// - Returns: A unique key
	private func generateKey(for location: Landmark) -> String {
		location.id + UUID().uuidString
	}
    
    /// Adds the downloaded image to the array of downloadaded images
    /// - Parameters:
    ///   - key: Image's id
    ///   - value: Image as UIImage
	private func appendDownloadedImages(for key: String, value: UIImage) {
		downloadedImages[key] = value
	}
	
	///All downloaded thumbnails identified by the Location's id
	@Published var downloadedThumbnails:[String: UIImage] = [:]
    
    /// Downloads all the thumbnails for a set of Landmarks
    /// - Parameter locations: Araray of all the Landmarks
	func downloadThumbails(for locations: [Landmark]) async {
		do {
			for location in locations {
				URLSession
                    .shared
                    .dataTaskPublisher(for: try buildUrl(for: location.thumbnailImage))
					.map { UIImage(data: $0.data) }
					.receive(on: DispatchQueue.main)
					.sink { _ in
					} receiveValue: { [weak self] downloadedImage in
						guard let self = self else { return }
						
						if let validDownloadedImage = downloadedImage {
							self.appenddownloadedThumbnails(for: self.generateKey(for: location), value: validDownloadedImage)
						}
					}
					.store(in: &cancellables)
			}
		}catch let error {
			print(error)
		}
	}
	
    /// Adds the downloaded thumbnails to the array of downloadaded thumbnails
    /// - Parameters:
    ///   - key: Image's id
    ///   - value: Image as UIImage
	private func appenddownloadedThumbnails(for key: String, value: UIImage) {
		downloadedThumbnails[key] = value
	}
	
}
