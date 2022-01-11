//
//  LocationViewModel.swift
//  Landmarker
//
//  Created by Federico Imberti on 25/12/21.
//

import Foundation
import MapKit
import SwiftUI

class LocationsViewModel: ObservableObject {
        
    @Published var isLocationListShown = false
    @Published var is3DShown = true
    @Published var isSheetShown = false
    @Published var centerImage = false
    
    var arrowRotationAmount:CGFloat {
        isLocationListShown ? -180 : 0
    }
    
    func toggleLocationsList(){
        withAnimation(.spring()){
            self.isLocationListShown.toggle()
        }
    }
    
    func toggle3D(){
        withAnimation(.linear){
            is3DShown.toggle()
        }
    }
    
}
