//
//  Item.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/9/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import Foundation
import UIKit

class Item {
    var id: String!
    var categoryID: String!
    var name: String!
    var description: String!
    var price: Double!
    var imageLinks: [String]!
    
    
    init(){
    }
    
    init(_dictionary: NSDictionary){
        id = _dictionary[kOBJECTID] as? String
        categoryID = _dictionary[kCATEGORYID] as? String
        name = _dictionary[kNAME] as? String
        description = _dictionary[kDESCRIPTION] as? String
        price = _dictionary[kPRICE] as? Double
        imageLinks = _dictionary[kIMAGELINKS] as? [String]
    }
}

//Mark: Save items func

func saveItemToFireStore(_ item: Item){
    
    FirebaseReference(.Items).document(item.id).setData(itemDictionaryFrom(item) as! [String: Any])
}
//Mark: Helper functions for items

func itemDictionaryFrom(_ item: Item) -> NSDictionary {
    
    return NSDictionary(objects: [item.id, item.categoryID, item.name, item.description, item.price, item.imageLinks], forKeys: [kOBJECTID as NSCopying, kCATEGORYID  as NSCopying, kNAME  as NSCopying, kDESCRIPTION  as NSCopying, kPRICE as NSCopying, kIMAGELINKS as NSCopying])
    
}
