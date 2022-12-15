//
//  CacheImage.swift
//  BookStore_LuizVasconcellos
//
//  Created by Luiz Vasconcellos on 11/12/22.
//

import Foundation

class CacheImage: NSObject {
    
    static let cache = CacheImage()
    let imageCache = NSCache<AnyObject, AnyObject>()
}
