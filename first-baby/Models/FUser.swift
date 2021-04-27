//
//  FUser.swift
//  first-baby
//
//  Created by Max Wen on 3/11/21.
//

import Foundation
import Firebase
import FirebaseAuth
import UIKit

class FUser {
    var objectId:String
    var userName:String
    var email:String
    var admin:Bool
    var verify:Bool
    var userDictionary: NSDictionary{
        return NSDictionary(objects: [
            self.objectId,self.userName,self.email,self.admin,self.verify,
        ],
                            forKeys: [kOBJECTID as NSCopying,kUSERNAME as NSCopying,kEMAIL as NSCopying,kADMIN as NSCopying,kVERIFY as NSCopying
                            ])
    }
    
    init(_objectId:String,_username:String,_emal:String){
        objectId = _objectId
        userName = _username
        email = _emal
        admin = false
        verify = false
    }
    init(_dictionary: NSDictionary){
        objectId = _dictionary[kOBJECTID] as? String ?? ""
        userName = _dictionary[kUSERNAME] as? String ?? ""
        email = _dictionary[kEMAIL] as? String ?? ""
        admin = _dictionary[kADMIN] as? Bool ?? false
        verify = _dictionary[kVERIFY] as? Bool ?? false
    }
    //current info
    class func currentId() -> String {
        if Auth.auth().currentUser != nil {
        return Auth.auth().currentUser!.uid
        }
        return ""
    }
    class func currentUser() -> FUser? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                return FUser.init(_dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
    class func registerUserWith(email:String,password:String,userName:String,completion:@escaping(_ error:Error?) ->Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            completion(error)
            if error == nil{
                authDataResult!.user.sendEmailVerification { (error) in
                    print("verification email")
                }
                if authDataResult?.user != nil{
                    let user = FUser(_objectId: authDataResult!.user.uid,_username: userName,_emal: email)
                    user.saveUserLocally()
                    FirestoreClass().saveUserToFirestore(user: user)
                }
            }
        }
    }
    
    func saveUserLocally(){
        UserDefaults.standard.setValue(self.userDictionary as! [String:Any], forKey: kCURRENTUSER)
        UserDefaults.standard.synchronize()
    }




}
