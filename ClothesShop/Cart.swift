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
    
    static let DocumentsDirectory: AnyObject = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("cart")
    
    struct PropertyKey {
        static let clothesKey = "clothes"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(clothesInCart, forKey: PropertyKey.clothesKey)
    }
    
    init(clothes: Array<Clothes>) {
        self.clothesInCart = clothes
        
        super.init()
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let clothes = aDecoder.decodeObjectForKey(PropertyKey.clothesKey) as! Array<Clothes>
        self.init(clothes: clothes)
    }
    
}
