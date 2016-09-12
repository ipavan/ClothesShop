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
    
    static func getUniqueId() -> Int {
        let id = NSKeyedUnarchiver.unarchiveObjectWithFile(UniqueCartIds.ArchiveURL.path!) as? UniqueCartIds
        if let cartId = id {
            //file exists
            var uniqueId = cartId
            uniqueId.cartId += 1
            let _ = NSKeyedArchiver.archiveRootObject(uniqueId, toFile: UniqueCartIds.ArchiveURL.path!)
            return uniqueId.cartId
        }
        else {
            //no file exists
            let uniqueId = UniqueCartIds(cartId: 1)
            let _ = NSKeyedArchiver.archiveRootObject(uniqueId, toFile: UniqueCartIds.ArchiveURL.path!)
            return uniqueId.cartId
        }
    }
    
}