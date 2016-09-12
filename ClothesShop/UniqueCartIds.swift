//
//  UniqueCartIds.swift
//  ClothesShop
//
//  Created by Divya Mirchandani on 9/12/16.
//  Copyright (c) 2016 pavansadarangani. All rights reserved.
//

import Foundation

class UniqueCartIds: NSObject, NSCoding {
    var cartId: Int
    
    init(cartId: Int) {
        self.cartId = cartId
        
        super.init()
    }
    
    static let DocumentsDirectory: AnyObject = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("cartIds")
    
    struct PropertyKey {
        static let uniqueKey = "uniqueKey"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(cartId, forKey: PropertyKey.uniqueKey)
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObjectForKey(PropertyKey.uniqueKey) as! Int
        
        self.init(cartId: id)
    }
    
}