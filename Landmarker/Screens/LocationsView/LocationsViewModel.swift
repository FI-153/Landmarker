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
    
    
    ///Toggles the activation of the drop-down menu to select locations
     func toggleLocationsList(){
        withAnimation(.spring()){
            self.isLocationListShown.toggle()
        }
    }
    
}
