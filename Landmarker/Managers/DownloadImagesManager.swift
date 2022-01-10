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
    
    static let shared = DownloadImagesManager()
    private init(){}
    
    var cancellables = Set<AnyCancellable>()
    var imageCacheManager = ImageCacheManager.shared
    
    @Published var downloadedImages:[String: UIImage] = [:]
    @Published var downloadedThumbnails:[String: UIImage] = [:]
    
    func downloadImages(for location: Location){
        
        for locationImageUrl in location.imageNames {
            
            guard let url = URL(string: locationImageUrl) else {
                return
            }
            
            URLSession.shared.dataTaskPublisher(for: url)
                .map { UIImage(data: $0.data) }
                .receive(on: DispatchQueue.main)
                .sink { _ in
                } receiveValue: { [weak self] downloadedImage in
                    guard let self = self else { return }
                    
                    if let validDownloadedImage = downloadedImage {
                        self.downloadedImages[location.id] = validDownloadedImage
                        self.imageCacheManager.addImage(named: location.id as NSString, image: validDownloadedImage)
                    }
                }
                .store(in: &cancellables)
        }
        
    }
    
    func downloadThumbails(for locations: [Location]){
        print("entered")
        for location in locations {
            print("Downloading for \(location.id)")
            
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
                        self.downloadedThumbnails[location.id] = validDownloadedImage
                        print("Downloaded for \(location.id)")
                    }
                }
                .store(in: &cancellables)

        }
    }
    
    func downloadThumbnails(){
        
    }
    
    
}
