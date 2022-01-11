//
//  Location.swift
//  Landmarker
//
//  Created by Federico Imberti on 25/12/21.
//

import Foundation
import MapKit

struct Location: Identifiable, Equatable, Decodable{

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
    let thumbnailImage:String
    let link:String
    
    let optimalDistance:CLLocationDistance
    let optimalPitch:CGFloat
    let optimalHeading:CLLocationDirection
    
    init(name: String, cityName: String, coordinates: CLLocationCoordinate2D, description: String, imageNames: [String], thumbnailImage:String, link: String, optimalDistance: CLLocationDistance, optimalPitch: CGFloat, optimalHeading: CLLocationDirection) {
        self.name = name
        self.cityName = cityName
        self.coordinates = coordinates
        self.description = description
        self.imageNames = imageNames
        self.thumbnailImage = thumbnailImage
        self.link = link
        self.optimalDistance = optimalDistance
        self.optimalPitch = optimalPitch
        self.optimalHeading = optimalHeading
    }
    
    private enum CodingKeys: String, CodingKey {
        case name, cityName, latitude, longitude
        case description
        case imageNames, thumbnailImage, link, optimalDistance, optimalPitch, optimalHeading
    }
    
    init(from decoder: Decoder) throws {
        let container = try! decoder.container(keyedBy: CodingKeys.self)
        
        self.name = try! container.decode(String.self, forKey: .name)
        self.cityName = try! container.decode(String.self, forKey: .cityName)
        
        let latitude = try! container.decode(Double.self, forKey: .latitude)
        let longitude = try! container.decode(Double.self, forKey: .longitude)
        self.coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        self.description = try! container.decode(String.self, forKey: .description)
        self.imageNames = try! container.decode([String].self, forKey: .imageNames)
        self.thumbnailImage = try! container.decode(String.self, forKey: .thumbnailImage)
        self.link = try! container.decode(String.self, forKey: .link)
        self.optimalDistance = try! container.decode(CLLocationDistance.self, forKey: .optimalDistance)
        self.optimalPitch = try! container.decode(CGFloat.self, forKey: .optimalPitch)
        self.optimalHeading = try! container.decode(CLLocationDirection.self, forKey: .optimalHeading)
        
    }
    
    ///Mock data to be used during development
    static let mockLocations: [Location] = [
        Location(
            name: "Mock",
            cityName: "mockCity",
            coordinates: CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922),
            description: ".",
            imageNames: [
                "",
                "",
                "",
            ],
            thumbnailImage: "",
            link: "",
            optimalDistance: 1200,
            optimalPitch: 80,
            optimalHeading: 0)
    ]

    
    
}
