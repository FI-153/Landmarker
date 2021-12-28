//
//  LocationDetailViewModel.swift
//  Landmarker
//
//  Created by Federico Imberti on 28/12/21.
//

import Foundation
import SwiftUI

class LocationDetailViewModel: ObservableObject {
    
    @Binding var isSheetShown:Bool
    
    init(isSheetShown: Binding<Bool>) {
        _isSheetShown = isSheetShown
    }
    
    func getDirections(to location:Location) {
        let latitude = location.coordinates.latitude
        let longitude = location.coordinates.longitude
        
        if let url = URL(string: "maps://?daddr=\(latitude),\(longitude)&dirflg=w") {
            if UIApplication.shared.canOpenURL(url){
                //Opens the Maps app with directions to the desired landmark from the current position
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}


