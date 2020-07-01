//
//  Item.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/9/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import Foundation
import UIKit
import InstantSearchClient

class Item {
    var id: String!
    var categoryID: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    var ownerID: String!
    var views: Double!
    
    
    init(){
    }
    
    init(_dictionary: NSDictionary){
        id = _dictionary[kOBJECTID] as? String
        categoryID = _dictionary[kCATEGORYID] as? String
        name = _dictionary[kNAME] as? String
        description = _dictionary[kDESCRIPTION] as? String
        price = _dictionary[kPRICE] as? Double
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
        ownerID = _dictionary[kOWNERID] as? String
        
    }
}

//Mark: Save items func

func saveItemToFireStore(_ item: Item){
    
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String: Any])
}
//Mark: Helper functions for items

func itemDictionaryFrom(_ item: Item) -> NSDictionary {
    
    return NSDictionary(objects: [item.ownerID, item.views, item.id, item.categoryID, item.name, item.description, item.price, item.imageLinks], forKeys: [kOBJECTID as NSCopying, kCATEGORYID  as NSCopying, kNAME  as NSCopying, kDESCRIPTION  as NSCopying, kPRICE as NSCopying, kIMAGELINKS as NSCopying, kOBJECTID as NSCopying, kITEMVIEWS as NSCopying])
    
}

//MARK: Download Func
func downloadItemsFromFirebase(_ withCategoryId: String, completion: @escaping (_ itemArray: [Item]) -> Void) {
    
    var itemArray: [Item] = []
    
    FirebaseReference(.Items).whereField(kCATEGORYID, isEqualTo: withCategoryId).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(itemArray)
            return
        }
        
        if !snapshot.isEmpty {
            
            for itemDict in snapshot.documents {
                
                itemArray.append(Item(_dictionary: itemDict.data() as NSDictionary))
            }
        }
        
        completion(itemArray)
    }
    
}

func downloadItems(_ withIDs: [String], completion: @escaping (_ itemArray: [Item]) -> Void) {
    
    var count = 0
    var itemArray: [Item] = []
    
    if withIDs.count > 0 {
        
        for itemID in withIDs {
            FirebaseReference(.Items).document(itemID).getDocument { (snapshot, error) in
                
                guard let snapshot = snapshot else {
                    completion(itemArray)
                    return
                }
                
                if snapshot.exists {
                    
                    itemArray.append(Item(_dictionary: snapshot.data()! as NSDictionary))
                    count += 1
                } else {
                    completion(itemArray)
                }
                
                
                if count == withIDs.count {
                    completion(itemArray)
                }

            }
        }
    } else {
        completion(itemArray)
    }
}

//MARK: - Algolia Functions

func saveItemToAlgolia(item: Item) {
    
    let index = AlgoliaService.shared.index
    
    let itemToSave = itemDictionaryFrom(item) as! [String: Any]
    
    index.addObject(itemToSave, withID: item.id, requestOptions: nil) { (content, error) in
        
        if error != nil {
            print("Error: Unable to save to Algolia", error!.localizedDescription)
        } else {
            print("added to Algolia")
            
        }
    }
}

func searchAlgolia(searchString: String, completion: @escaping (_ itemArray: [String]) -> Void) {
    
    let index = AlgoliaService.shared.index
    var resultIDs: [String] = []
    
    let query = Query(query: searchString)
    
    query.attributesToRetrieve = ["name", "description"]
    
    index.search(query) { (content, error) in
        
        
        if error == nil {
            let cont = content!["hits"] as! [[String: Any]]
            
            resultIDs = []
            
            for result in cont {
                resultIDs.append(result["objectID"] as! String)
            }
            
            completion(resultIDs)
        } else {
            print("Error: Algolia Seard - ", error!.localizedDescription)
            completion(resultIDs)
        }
    }
}
