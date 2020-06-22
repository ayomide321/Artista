//
//  FireBaseCollectioNRefrence.swift
//  Artista
//
//  Created by Ayo Kuye on 6/1/20.
//  Copyright © 2020 Ayo Kuye. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case User
    case Category
    case Items
    case Basket
    
    
    }

func FirebaseReference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
    
}

