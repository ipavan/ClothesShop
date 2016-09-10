//
//  Clothes.swift
//  ClothesShop
//
//  Created by Divya Mirchandani on 9/10/16.
//  Copyright (c) 2016 pavansadarangani. All rights reserved.
//

import Foundation


class Clothes {
    
    let productId: Int
    let name: String
    let category: String
    let price: Int
    let oldPrice: Int?
    var stock: Int
    
    init(productId: Int, name: String, category: String, price: Int, oldPrice: Int?, stock: Int) {
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
    }
    
}