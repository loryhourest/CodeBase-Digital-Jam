//
//  ImageCache.swift
//  CodeBase
//
//  Created by Алихан  on 25.02.2025.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    private init() {}
    
    private var cache = NSCache<NSString, UIImage>()
    
    func image(forKey key: String) -> UIImage? {
        cache.object(forKey: key as NSString)
    }
    
    func insertImage(_ image: UIImage?, forKey key: String) {
        guard let image = image else {
            cache.removeObject(forKey: key as NSString)
            return
        }
        cache.setObject(image, forKey: key as NSString)
    }
}



