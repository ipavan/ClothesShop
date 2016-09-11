//
//  Wishlist.swift
//  ClothesShop
//
//  Created by Divya Mirchandani on 9/11/16.
//  Copyright (c) 2016 pavansadarangani. All rights reserved.
//

import UIKit

class Wishlist: NSObject, NSCoding {
    
    var clothesWishlist: Array<Clothes> = []
    
    static let DocumentsDirectory: AnyObject = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("wishes")
    
    struct PropertyKey {
        static let wishKey = "wishlist"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(clothesWishlist, forKey: PropertyKey.wishKey)
    }
    
    init(clothes: Array<Clothes>) {
        self.clothesWishlist = clothes
        
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let clothes = aDecoder.decodeObjectForKey(PropertyKey.wishKey) as! Array<Clothes>
        
        self.init(clothes: clothes)
    }
    
}
