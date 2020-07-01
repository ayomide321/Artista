//
//  Category.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/9/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import Foundation
import UIKit

class Category {
    var id: String
    var name: String
    var image: UIImage?
    var imageName: String?

    init(_name: String, _imageName: String) {
        
        id = ""
        name = _name
        imageName = _imageName
        image = UIImage(named: _imageName)
    }
    
    init(_dictionary: NSDictionary) {
        id = _dictionary[kOBJECTID] as! String
        name = _dictionary[kNAME] as! String
        image = UIImage(named: _dictionary[kIMAGENAME] as? String ?? "")
    }
}

//MARK: Download category from firebase

func downloadCategoriesFromFirebase(completion: @escaping (_ categoryArray: [Category]) -> Void) {
    
    var categoryArray: [Category] = []
    
    FirebaseReference(.Category).getDocuments { (snapshot, error) in
        
        guard let snapshot = snapshot else {
            completion(categoryArray)
            return
        }
        
        if !snapshot.isEmpty {
            
            for categoryDict in snapshot.documents {
                categoryArray.append(Category(_dictionary: categoryDict.data() as NSDictionary))
            }
        }
        
        completion(categoryArray)
    }
}
//MARK: Save category function

func saveCategoryToFirebase(_ category: Category) {
    
    let id = UUID().uuidString
    category.id = id
    
    FirebaseReference(.Category).document(id).setData(categoryDictionaryFrom(category)
        as! [String: Any])
}


//MARK: Helpers

func categoryDictionaryFrom(_ category: Category) -> NSDictionary {
    
    return NSDictionary(objects: [category.id, category.name, category.imageName], forKeys: [kOBJECTID as NSCopying, kNAME as NSCopying, kIMAGENAME as NSCopying])
}

//use only one time

func createCategorySet() {
    
    let photography = Category(_name: "Photography", _imageName: "camera")
    let sculpture = Category(_name: "Sculpture", _imageName: "statue")
    let painting = Category(_name: "Painting", _imageName: "paintbrush")
    let drawing = Category(_name: "Drawing", _imageName: "pencil")
    let etching = Category(_name: "Etching", _imageName: "ceramic")
    let graphic_design = Category(_name: "Graphix Design", _imageName: "computer")
    let vfx = Category(_name: "VFX", _imageName: "video")
    
    let arrayOfCategories = [photography, sculpture, painting, drawing, etching, graphic_design, vfx]
    
    for category in arrayOfCategories {
        saveCategoryToFirebase(category)
    }
    
    
}
    


