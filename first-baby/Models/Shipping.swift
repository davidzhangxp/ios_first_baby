//
//  Shipping.swift
//  first-baby
//
//  Created by Max Wen on 4/14/21.
//

import Foundation

class Shipping {
    var firstName : String
    var lastName : String
    var address : String
    var city : String
    var postalCode : String
    var country : String
    var pickup : Bool
    var shippingDictionary:NSDictionary{
        return NSDictionary(objects: [self.firstName,self.lastName,self.address,self.city,self.postalCode,self.country,self.pickup], forKeys: [kFIRSTNAME as NSCopying,kLASTNAME as NSCopying,kADDRESS as NSCopying,kCITY as NSCopying,kPOSTALCODE as NSCopying,kCOUNTRY as NSCopying,kPICKUP as NSCopying])
    }
    
    init(){
        firstName = ""
        lastName = ""
        address = ""
        city = ""
        postalCode = ""
        country = ""
        pickup = false
    }
    init(_dictionary:NSDictionary) {
        firstName = _dictionary[kFIRSTNAME] as? String ?? ""
        lastName = _dictionary[kLASTNAME] as? String ?? ""
        address = _dictionary[kADDRESS] as? String ?? ""
        city = _dictionary[kCITY] as? String ?? ""
        postalCode = _dictionary[kPOSTALCODE] as? String ?? ""
        country = _dictionary[kCOUNTRY] as? String ?? ""
        pickup = _dictionary[kPICKUP] as? Bool ?? false
    }
    
}
