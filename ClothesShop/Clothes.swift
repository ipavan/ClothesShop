//
//  Clothes.swift
//  ClothesShop
//
//  Created by Divya Mirchandani on 9/10/16.
//  Copyright (c) 2016 pavansadarangani. All rights reserved.
//

import Foundation


class Clothes: NSObject, NSCoding {
    
    let productId: Int
    let name: String
    let category: String
    let price: Int
    let oldPrice: Int?
    var stock: Int
    var numberInCart: Int?
    
    init(productId: Int, name: String, category: String, price: Int, oldPrice: Int?, stock: Int, numberInCart: Int?) {
        self.productId = productId
        self.name = name
        self.category = category
        self.price = price
        if let old = oldPrice {
            self.oldPrice = old
        }
        else {
            self.oldPrice = nil
        }
        self.stock = stock
        if let num = numberInCart {
            self.numberInCart = num
        }
        else {
            self.numberInCart = nil
        }
    }
    
    static let DocumentsDirectory: AnyObject = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("clothes")
    
    struct PropertyKey {
        static let productIdKey = "productId"
        static let nameKey = "name"
        static let categoryKey = "category"
        static let priceKey = "price"
        static let oldPriceKey = "oldprice"
        static let stockKey = "stock"
        static let numberInCartKey = "numberInCart"
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(productId, forKey: PropertyKey.productIdKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(category, forKey: PropertyKey.categoryKey)
        aCoder.encodeObject(price, forKey: PropertyKey.priceKey)
        aCoder.encodeObject(oldPrice, forKey: PropertyKey.oldPriceKey)
        aCoder.encodeObject(stock, forKey: PropertyKey.stockKey)
        aCoder.encodeObject(numberInCart, forKey: PropertyKey.numberInCartKey)
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        let prodId = aDecoder.decodeObjectForKey(PropertyKey.productIdKey) as! Int
        let prodName = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let prodCat = aDecoder.decodeObjectForKey(PropertyKey.categoryKey) as! String
        let prodPrice = aDecoder.decodeObjectForKey(PropertyKey.priceKey) as! Int
        let prodOldPrice = aDecoder.decodeObjectForKey(PropertyKey.oldPriceKey) as? Int
        let prodStock = aDecoder.decodeObjectForKey(PropertyKey.stockKey) as! Int
        let prodInCart = aDecoder.decodeObjectForKey(PropertyKey.numberInCartKey) as? Int
        
        self.init(productId: prodId, name: prodName, category: prodCat, price: prodPrice, oldPrice: prodOldPrice, stock: prodStock, numberInCart: prodInCart)
    }
    
    
}