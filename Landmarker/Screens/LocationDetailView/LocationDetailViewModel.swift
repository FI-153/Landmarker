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
    
    let location:Landmark
    
    let downloadImagesManager = DownloadImagesManager.getShared()
    
    var cancellables = Set<AnyCancellable>()
	var images:[UIImage] = []
    
    init(isSheetShown: Binding<Bool>, location:Landmark) {
		self._isSheetShown = isSheetShown
        self.location = location
        
        addSubscriberToImages()
    }
	
    func addSubscriberToImages(){
        downloadImagesManager.$downloadedImages.sink { [weak self] downloadedImages in
			guard let self = self else { return }
			
            for downloadedImage in downloadedImages {

				if downloadedImage.key.contains(self.location.id) {
					self.images.append(downloadedImage.value)
				}
				
            }
            
        }
        .store(in: &cancellables)
    }
    
}


