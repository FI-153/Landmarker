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
    static let shared = DownloadImagesManager()
    private init(){}
    
    var cancellables = Set<AnyCancellable>()
        
    ///Publishes all downloaded images identified by the Location's id
    @Published var downloadedImages:[String: UIImage] = [:]
	func downloadImages(for locations: [Landmark]){
		
		do {
			
			for location in locations {
				
				try location.imageNames.forEach {
					
					URLSession.shared.dataTaskPublisher(for: try buildUrl(for: $0))
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
	
	private func buildUrl(for locationImageUrl: String) throws -> URL {
		guard let url = URL(string: locationImageUrl) else {
			throw URLError(.badURL)
		}
		return url
	}
	
	private func generateKey(for location: Landmark) -> String {
		location.id + UUID().uuidString
	}
	
	private func appendDownloadedImages(for key: String, value: UIImage) {
		downloadedImages[key] = value
	}
    
    ///Publishes all downloaded thumbnails identified by the Location's id
    @Published var downloadedThumbnails:[String: UIImage] = [:]
    func downloadThumbails(for locations: [Landmark]){
        for location in locations {
            guard let url = URL(string: location.thumbnailImage) else {
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .receive(on: DispatchQueue.main)
                .sink { _ in
                } receiveValue: { [weak self] downloadedImage in
                    guard let self = self else { return }
                    
                    if let validDownloadedImage = downloadedImage {
                        self.downloadedThumbnails[location.id + UUID().uuidString] = validDownloadedImage
                        
                        //Add image to cache
                        //self.imageCacheManager.addImage(named: location.id as NSString, image: validDownloadedImage)

                    }
                }
                .store(in: &cancellables)
        }
    }
    
}
