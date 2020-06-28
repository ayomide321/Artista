//
//  MUser.swift
//  Artista
//
//  Created by Ayo Kuye on 6/27/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import Foundation
import FirebaseAuth

class MUser {
    let objectId: String
    var email: String
    var firstName: String
    var lastName: String
    var fullName: String
    var purchasedItemIds: [String]
    
    var fullAddress: String?
    var onBoard: Bool
    
    //MARK - Initializer
    
    init(_objectId: String, _email: String, _firstName: String, _lastName: String) {
        
        objectId = _objectId
        email = _email
        firstName = _firstName
        lastName = _lastName
        fullName = _firstName + " " + _lastName
        fullAddress = ""
        onBoard = false
        purchasedItemIds = []
        
    }
    
    init(_dictionary: NSDictionary) {
        
        objectId = _dictionary[kOBJECTID] as! String
        
        if let mail = _dictionary[kEMAIL] {
            email = mail as! String
        } else {
            email = ""
        }
        
        if let fname = _dictionary[kFIRSTNAME] {
                  firstName = fname as! String
              } else {
                  firstName = ""
              }
        if let lname = _dictionary[kLASTNAME] {
                  lastName = lname as! String
              } else {
                  lastName = ""
              }
        
        fullName = firstName + " " + lastName
        
        if let faddress = _dictionary[kFULLADDRESS] {
           fullAddress = faddress as! String
        } else {
           fullAddress = ""
        }
        if let onB = _dictionary[kONBOARD] {
          onBoard = onB as! Bool
        } else {
          onBoard = false
        }
        
        if let purchaseIds = _dictionary[kPURCHASEITEMIDS] {
         purchasedItemIds = purchaseIds as! [String]
       } else {
         purchasedItemIds = []
       }
   
    }
    
    
    //MARK: - Return Current User

    class func currentID() -> String {
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> MUser? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) {
                return MUser.init(_dictionary: dictionary as! NSDictionary)
            }
            
        }
        
        return nil
    }
    
}
