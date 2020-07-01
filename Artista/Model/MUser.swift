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
    var soldItemIds: [String]
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
        soldItemIds = []
        
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
        
        if let soldIds = _dictionary[kSOLDITEMIDS] {
            soldItemIds = soldIds as! [String]
        } else {
          soldItemIds = []
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
    
    //MARK: - Login func
    
    class func loginUserWith(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, error) in
            
            if error == nil {
                if authDataResult!.user.isEmailVerified {
                    
                    downloadUserFromFirestore(userId: authDataResult!.user.uid, email: email)
                   
                    completion(error, true)
                } else {
                    print("email is not verified")
                    completion(error, false)
                }
        } else {
            completion(error, false)
            
        }
    }

}
    //MARK: - Register func
    
    class func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) ->Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) {
            (AuthDataResult, error) in
            
            completion(error)
            
            if error == nil {
                
                //send email verification
                AuthDataResult?.user.sendEmailVerification(completion: { (error) in
                    print("auth email verification error : ", error?.localizedDescription)
                })
            }
            
        }
         
    }
    //MARK: - Resend link methods

    class func resetPasswordFor(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            completion(error)
        }
    }
    
    class func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().currentUser?.reload(completion: { (error) in
            
            Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                print(" resend email error: ", error?.localizedDescription)
                
                completion(error)
            })
        })
    }
    
    class func logOutCurrentUser(completion: @escaping (_ error: Error?) -> Void) {
        
        do {
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: kCURRENTUSER)
            UserDefaults.standard.synchronize()
            completion(nil)
            
            
        } catch let error as NSError {
            completion(error)
            
        
        }
    }
}// End of Class


//MARK: - Download User

func downloadUserFromFirestore(userId: String, email: String) {
    FirebaseReference(.User).document(userId).getDocument { (snapshot, error) in
        
        guard let snapshot = snapshot else { return }
        
        if snapshot.exists {
            print("download current user from firestore")
            saveUserLocally(mUserDictionary: snapshot.data()! as NSDictionary)
        } else {
            // There is No User, Save New in Firestore
            
            let user = MUser(_objectId: userId, _email: email, _firstName: "", _lastName: "")
            saveUserLocally(mUserDictionary: userDictionaryFrom(user: user))
            saveUserToFirestore(mUSER: user)
            
        }
        
        
    }
    
}
//MARK: - Save User to Fire Base

func saveUserToFirestore(mUSER: MUser) {
    
    
        FirebaseReference(.User).document(mUSER.objectId)
        .setData(userDictionaryFrom(user: mUSER) as! [String : Any]) { (error) in
        
        if error != nil {
            print("error saving user \(error!.localizedDescription)")
        }

    }
}

func saveUserLocally(mUserDictionary: NSDictionary) {
    UserDefaults.standard.set(mUserDictionary, forKey: kCURRENTUSER)
    UserDefaults.standard.synchronize()
}

//MARK: - Helper Function

func userDictionaryFrom(user: MUser) -> NSDictionary {
    
    return NSDictionary(objects: [user.objectId, user.email, user.firstName, user.lastName, user.fullName, user.fullAddress ?? "", user.onBoard, user.purchasedItemIds], forKeys: [kOBJECTID as NSCopying, kEMAIL as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying, kFULLADDRESS as NSCopying, kONBOARD as NSCopying, kPURCHASEITEMIDS as NSCopying])
}


//MARK: - Update User
func updateCurrentUserInFirestore(withValues: [String: Any], completion: @escaping (_ error: Error?) -> Void) {
    
    if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER){
        
    
        let userObject = (dictionary as! NSDictionary).mutableCopy() as! NSMutableDictionary
        userObject.setValuesForKeys(withValues)
        
        FirebaseReference(.User).document(MUser.currentID()).updateData(withValues) { (error) in
            
            completion(error)
            
            if error == nil {
                saveUserLocally(mUserDictionary: userObject)
            }
        }
    }
    

}
