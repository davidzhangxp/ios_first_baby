//
//  Basket.swift
//  first-baby
//
//  Created by Max Wen on 4/7/21.
//

import Foundation


class Basket {
    var id:String
    var productId: String
    var userId: String
    var productQty:Int
 
    var basketDictionary:NSDictionary{
        return NSDictionary(objects: [self.id,self.productId,self.userId,self.productQty], forKeys: [kID as NSCopying, kPRODUCTID as NSCopying, kUSERID as NSCopying,kPRODUCTQTY as NSCopying])
    }
    init() {
        id = ""
        productId = ""
        userId = ""
        productQty = 1
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kID] as? String ?? ""
        productId = _dictionary[kPRODUCTID] as? String ?? ""
        userId = _dictionary[kUSERID] as? String ?? ""
        productQty = _dictionary[kPRODUCTQTY] as? Int ?? 1
        
    }

    
}
