//
//  Cart.swift
//  ClothesShop
//
//  Created by Divya Mirchandani on 9/11/16.
//  Copyright (c) 2016 pavansadarangani. All rights reserved.
//

import UIKit

class Cart: NSObject, NSCoding {
    
    var clothesInCart: Array<Clothes> = []
    var clothesInWishlist: Array<Clothes> = []
    
    static let DocumentsDirectory: AnyObject = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("cart")
    
    struct PropertyKey {
        static let clothesKey = "clothes"
        //static let wishKey = "wishlist"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(clothesInCart, forKey: PropertyKey.clothesKey)
        //aCoder.encodeObject(clothesInWishlist, forKey: PropertyKey.wishKey)
    }
    
    init(clothes: Array<Clothes>) {
        self.clothesInCart = clothes
        //self.clothesInWishlist = wish
        
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let clothes = aDecoder.decodeObjectForKey(PropertyKey.clothesKey) as! Array<Clothes>
        //let wish = aDecoder.decodeObjectForKey(PropertyKey.wishKey) as! Array<Clothes>
        
        //self.init(clothes: clothes, wish: wish)
        self.init(clothes: clothes)
    }
    
}
