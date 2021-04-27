//
//  Product.swift
//  first-baby
//
//  Created by Max Wen on 3/28/21.
//

import Foundation

class Product {
    
    var productId: String
    var category: String
    var productName: String
    var description: String
    var productPrice: Double
    var productImg: String
    var productQty:Int
 
    var productDictionary:NSDictionary{
        return NSDictionary(objects: [self.productId,self.category,self.productName,self.description,self.productPrice,self.productImg,self.productQty], forKeys: [kPRODUCTID as NSCopying, kCATEGORY as NSCopying, kPRODUCTNAME as NSCopying,kDESCRIPTION as NSCopying,kPRODUCTPRICE as NSCopying,kPRODUCTIMG as NSCopying,kPRODUCTQTY as NSCopying])
    }
    init(_productId:String,_productName:String,_productPrice:Double) {
        productId = _productId
        category = ""
        productName = _productName
        description = ""
        productPrice = _productPrice
        productImg = ""
        productQty = 0
    }
    
    init(_dictionary: NSDictionary) {
        productId = _dictionary[kPRODUCTID] as? String ?? ""
        category = _dictionary[kCATEGORY] as? String ?? ""
        productName = _dictionary[kPRODUCTNAME] as? String ?? ""
        description = _dictionary[kDESCRIPTION] as? String ?? ""
        productPrice = _dictionary[kPRODUCTPRICE] as? Double ?? 0.0
        productImg = _dictionary[kPRODUCTIMG] as? String ?? ""
        productQty = _dictionary[kPRODUCTQTY] as? Int ?? 0
    }
    
}
