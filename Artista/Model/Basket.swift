//
//  Basket.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/27/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import Foundation


class Basket {
    
    var id: String!
    var ownerID: String!
    var itemIDs: [String]!
    
    init() {
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as? String
        ownerID = _dictionary[kOWNERID] as? String
        itemIDs = _dictionary[kITEMIDS] as? [String]
    }
}


//MARK: - Download items
func downloadBasketFromFirestore(_ ownerID: String, completion: @escaping (_ basket: Basket?)-> Void) {
    
    FirebaseReference(.Basket).whereField(kOWNERID, isEqualTo: ownerID).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            
            completion(nil)
            return
        }
        
        if !snapshot.isEmpty && snapshot.documents.count > 0 {
            let basket = Basket(_dictionary: snapshot.documents.first!.data() as NSDictionary)
            completion(basket)
        } else {
            completion(nil)
        }
    }
}


//MARK: - Save to Firebase
func saveBasketToFirestore(_ basket: Basket) {
    
    FirebaseReference(.Basket).document(basket.id).setData(basketDictionaryFrom(basket) as! [String: Any])
}


//MARK: Helper functions

func basketDictionaryFrom(_ basket: Basket) -> NSDictionary {
    
    return NSDictionary(objects: [basket.id, basket.ownerID, basket.itemIDs], forKeys: [kOBJECTID as NSCopying, kOWNERID as NSCopying, kITEMIDS as NSCopying])
}

//MARK: - Update Basket
func updateBasketInFirestore(_ basket: Basket, withValues: [String: Any], completion: @escaping (_ error: Error?) -> Void) {
    
    
    FirebaseReference(.Basket).document(basket.id).updateData(withValues) { (error) in
        
        completion(error)
    }
}


