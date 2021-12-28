//
//  Location.swift
//  Landmarker
//
//  Created by Federico Imberti on 25/12/21.
//

import Foundation
import MapKit

struct Location: Identifiable, Equatable{
    static func == (lhs: Location, rhs: Location) -> Bool {
        lhs.id == rhs.id
    }
    
    var id:String {
      name+cityName
    }
    
    let name:String
    let cityName:String
    let coordinates:CLLocationCoordinate2D
    let description:String
    let imageNames:[String]
    let link:String
    
    let optimalDistance:CLLocationDistance
    let optimalPitch:CGFloat
    let optimalHeading:CLLocationDirection
    
}
