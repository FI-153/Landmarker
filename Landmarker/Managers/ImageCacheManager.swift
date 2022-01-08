//
//  CacheManager.swift
//  Landmarker
//
//  Created by Federico Imberti on 08/01/22.
//

import Foundation
import UIKit

class ImageCacheManager {
    
    ///Singleton instance of ImageCacheManager
    static let shared = ImageCacheManager()
    private init(){}
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 15
        cache.totalCostLimit = 1024^2*100 //approx. 100MB
        
        return cache
    }()
    
    func addImage(named name:NSString, image:UIImage){
        imageCache.setObject(image, forKey: name)
    }
    
    func removeImage(named name:NSString) {
        imageCache.removeObject(forKey: name)
    }
    
    func fetchImage(named name:NSString) -> UIImage?{
        return imageCache.object(forKey: name)
    }
    
}
