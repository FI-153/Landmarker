//
//  LocationDetailViewModel.swift
//  Landmarker
//
//  Created by Federico Imberti on 28/12/21.
//

import Foundation
import SwiftUI
import Combine

class LocationDetailViewModel: ObservableObject {
    
    @Binding var isSheetShown:Bool
    
    let location:Location
    
    let downloadImagesManager = DownloadImagesManager.shared
    
    var cancellables = Set<AnyCancellable>()
    var images:[String:UIImage] = [:]
    
    init(isSheetShown: Binding<Bool>, location:Location) {
        _isSheetShown = isSheetShown
        self.location = location
        
        downloadImagesManager.downloadImages(for: location)
        addSubscriberToImages()
    }
    
    func addSubscriberToImages(){
        downloadImagesManager.$downloadedImages.sink { downloadedImages in
            
            for downloadedImage in downloadedImages {
                
                if !self.images.contains(where: { (key: String, _: UIImage) in
                    key == downloadedImage.key
                }) {
                    self.images[downloadedImage.key] = downloadedImage.value
                }
                
            }
            
        }
        .store(in: &cancellables)
    }
    
}


