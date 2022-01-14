//
//  LocationPreviewViewModel.swift
//  Landmarker
//
//  Created by Federico Imberti on 11/01/22.
//

import SwiftUI
import Combine
import UIKit

class LocationPreviewViewModel:ObservableObject {
    
    let location:Location

    @Binding var is3DShown:Bool
    @Binding var isSheetShown:Bool
    init(location:Location, is3DShown:Binding<Bool>, isSheetShown:Binding<Bool>){
        self.location = location
        self._is3DShown = is3DShown
        self._isSheetShown = isSheetShown
        
        downloadImageManager.downloadImages(for: location)
        addSubscriberToPreviewImage()
    }
    
    @Published var thumbnailImage:UIImage?
    let downloadImageManager = DownloadImagesManager.shared
    var cancellables = Set<AnyCancellable>()
    func addSubscriberToPreviewImage(){
        downloadImageManager.$downloadedThumbnails.sink { downloadedImage in
            
            for key in downloadedImage.keys {
                if key.hasPrefix(self.location.id) {
                    if let image = downloadedImage[key] {
                        self.thumbnailImage = image
                    }
                    
                }
            }
        }
        .store(in: &cancellables)
    }
}
