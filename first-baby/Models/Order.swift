//
//  Order.swift
//  first-baby
//
//  Created by Max Wen on 4/23/21.
//

import Foundation
class Order {
    var userId:String
    var orderItems: [[String:Any]]
    var shipping:[String:Any]
    var itemsPrice: Double
    var shippingPrice: Double
    var taxPrice: Double
    var totalPrice: Double
    var isPaid: Bool
    var orderID: String
    var date: Date
    var shippingout: Bool
 
    var orderDictionary:NSDictionary{
        return NSDictionary(objects: [self.userId,self.orderItems,self.shipping,self.itemsPrice,self.shippingPrice,self.taxPrice,self.totalPrice,self.isPaid,self.orderID,self.date,self.shippingout], forKeys: [kUSERID as NSCopying, kORDERITEMS as NSCopying, kSHIPPING as NSCopying,kITEMSPRICE as NSCopying,kSHIPPINGPRICE as NSCopying,kTAXPRICE as NSCopying,kTOTALPRICE as NSCopying,kISPAID as NSCopying,kORDERID as NSCopying,kDATE as NSCopying,kSHIPPINGOUT as NSCopying])
    }
    init() {
        userId = ""
        orderItems = [[:]]
        shipping = [:]
        itemsPrice = 0.0
        shippingPrice = 0.0
        taxPrice = 0.0
        totalPrice = 0.0
        isPaid = false
        orderID = ""
        date = Date()
        shippingout = false
    }
    
    init(_dictionary: NSDictionary) {
        userId = _dictionary[kUSERID] as? String ?? ""
        orderItems = _dictionary[kORDERITEMS] as? [[String:Any]] ?? [[:]]
        shipping = _dictionary[kSHIPPING] as? [String:Any] ?? [:]
        itemsPrice = _dictionary[kITEMSPRICE] as? Double ?? 0.0
        shippingPrice = _dictionary[kSHIPPINGPRICE] as? Double ?? 0.0
        taxPrice = _dictionary[kTAXPRICE] as? Double ?? 0.0
        totalPrice = _dictionary[kTOTALPRICE] as? Double ?? 0.0
        isPaid = _dictionary[kISPAID] as? Bool ?? false
        orderID = _dictionary[kORDERID] as? String ?? ""
        date = _dictionary[kDATE] as? Date ?? Date()
        shippingout = _dictionary[kSHIPPINGOUT] as? Bool ?? false
    }

    
}
