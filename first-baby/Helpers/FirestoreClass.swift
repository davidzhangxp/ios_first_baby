//
//  FirestoreClass.swift
//  first-baby
//
//  Created by Max Wen on 3/12/21.
//

import Foundation
import FirebaseFirestore

let mFirestore = Firestore.firestore()

class FirestoreClass {
    init(){}
    func saveUserToFirestore(user:FUser){
        mFirestore.collection(kUSERS).document(user.objectId).setData(user.userDictionary as! [String : Any]) { (error) in
            if error != nil {
                print("error saving user",error!.localizedDescription)
            }
        }
    }
    //Update user
    func updateCurrentUserInFirestore(withValues:[String:Any], completion: @escaping (_ error: Error?) -> Void) {
        
        if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
            let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
            userObject.setValuesForKeys(withValues)
            
            mFirestore.collection(kUSERS).document(FUser.currentId()).updateData(withValues) { error in
                
                completion(error)
                if error == nil {
                    FUser(_dictionary: userObject).saveUserLocally()
                }
            }
        }
    }
    
    func  downloadCurrentUserFromFirebase(userId:String,email:String,name:String) {
        mFirestore.collection(kUSERS).document(userId).getDocument { (snapshot, error) in
            guard let snapshot = snapshot else {return}
            if snapshot.exists{
                let user = FUser(_dictionary: snapshot.data()! as NSDictionary)
                if user.verify == false{
                    user.verify = true
                    user.saveUserLocally()
                    self.saveUserToFirestore(user: user)
                }else{
                    user.saveUserLocally()
                }
            }else{
                let user = FUser(_objectId: userId,_username: name,_emal: email)
                user.verify = true
                user.saveUserLocally()
                self.saveUserToFirestore(user: user)
            }
        }
    }
    func saveProductToFirestore(product:Product){
        mFirestore.collection(kPRODUCT).document(product.productId).setData(product.productDictionary as! [String : Any]) { (error) in
            if error != nil {
                print("error saving user",error!.localizedDescription)
            }
        }
    }
    func downloadProductsFromFirestore(completion:@escaping(_ productArray:[Product])->Void ){
        var productArray:[Product]=[]
        mFirestore.collection(kPRODUCT).getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else{ completion(productArray)
                return}
            if !snapshot.isEmpty{
                for productDic in snapshot.documents{
                    productArray.append(Product(_dictionary: productDic.data() as NSDictionary))
                }
            }   
            completion(productArray)
        }
    }
    
    func saveBasketToFirestore(basket:Basket){
        mFirestore.collection(kBASKET).document(basket.id).setData(basket.basketDictionary as! [String : Any]) { (error) in
            if error != nil {
                print("error saving user",error!.localizedDescription)
            }
        }
    }
    
    //Download basket check if user already has this item
    func downloadBasketFromFirebase(userId: String, productId:String,completion: @escaping(_ basket: Basket?) -> Void){
        
        mFirestore.collection(kBASKET).whereField(kUSERID, isEqualTo: userId).whereField(kPRODUCTID, isEqualTo: productId).getDocuments { (snapshot, error) in
           
            guard let snapshot = snapshot else {
                completion(nil)
                return
            }
            if !snapshot.isEmpty && snapshot.documents.count > 0 {
                let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
                completion(basket)
            } else{
            completion(nil)
            }
        }
    }
    
    func updateBasketInFirestore(_ basket: Basket, withValues: [String: Any],completion: @escaping (_ error: Error?) -> Void) {
        mFirestore.collection(kBASKET).document(basket.id).updateData(withValues) {(error) in
            completion(error)
        }
    }
    //download user all baskets
    func downloadAllBasketFromFirebase(_ userId: String, completion: @escaping(_ baskets: [Basket]) -> Void){
        
        var basketArray:[Basket]=[]
        mFirestore.collection(kBASKET).whereField(kUSERID, isEqualTo: userId).getDocuments { (snapshot, error) in
           
            guard let snapshot = snapshot else {
                completion(basketArray)
                return
            }
            if !snapshot.isEmpty && snapshot.documents.count > 0 {
                for docoment in snapshot.documents{
                    let basket = Basket(_dictionary: docoment.data() as NSDictionary)
                    basketArray.append(basket)
                }
                
                completion(basketArray)
            } else{
            completion(basketArray)
            }
        }
    }
    func downloadItems(_ baskets: [Basket],completion: @escaping(_ itemArray: [Product]) -> Void){
        
        var itemArray:[Product] = []
        var count = 0

        if baskets.count > 0 {
            for basket in baskets {
                mFirestore.collection(kPRODUCT).document(basket.productId).getDocument { (snapshot, error) in
                    guard let snapshot = snapshot else{
                        completion(itemArray)
                        return
                    }
                    if snapshot.exists{
                        let product = Product(_dictionary: snapshot.data()! as NSDictionary)
                        product.productQty = basket.productQty
                        itemArray.append(product)
                        count += 1
                    } else {
                        completion(itemArray)
                    }
                    if count == baskets.count {
                        completion(itemArray)
                    }
                }
            }
        } else{
            completion(itemArray)
        }
    }
    
    func deletBasketObject(basketId:String){
        mFirestore.collection(kBASKET).document(basketId).delete()
    }
    
    func setNewOder(order:Order){
        mFirestore.collection(kORDER).document(order.orderID).setData( order.orderDictionary as! [String:Any]){(error) in
            
        }
    }
    func deleteBasketFromFirestore(){
        mFirestore.collection(kBASKET).whereField(kUSERID, isEqualTo: FUser.currentId())
            .getDocuments { (snapshot, error) in
                guard let snapshot = snapshot else {
                    return
                }
                if !snapshot.isEmpty && snapshot.documents.count > 0 {
                    for document in snapshot.documents{
                        let basket = Basket(_dictionary: document.data() as NSDictionary)
                        mFirestore.collection(kBASKET).document(basket.id).delete()
                    }
                }
            }
    }
}
