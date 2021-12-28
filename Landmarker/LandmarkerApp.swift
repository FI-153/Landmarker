//
//  LandmarkerApp.swift
//  Landmarker
//
//  Created by Federico Imberti on 25/12/21.
//

import SwiftUI

@main
struct LandmarkerApp: App {
    
    @StateObject var locationManager = LocationsManager()
    
    var body: some Scene {
        WindowGroup {
            LocationsView()
                .environmentObject(locationManager)
        }
    }
}
