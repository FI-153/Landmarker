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
    
    let location:Location
    
    init(isSheetShown: Binding<Bool>, location:Location) {
        _isSheetShown = isSheetShown
        self.location = location
    }
    
}


