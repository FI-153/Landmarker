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
    @Published var images:[UIImage?] = []
    init(isSheetShown: Binding<Bool>, location:Location) {
        _isSheetShown = isSheetShown
        self.location = location
        
        downloadImagesManager.downloadImages(for: location)
        addSubscriberToImages()
    }

    func addSubscriberToImages(){
        downloadImagesManager.$downloadedImages.sink { image in
            if let imageName = image[self.location.id] {
                self.images.append(imageName)
            }
        }
        .store(in: &cancellables)
    }

}


