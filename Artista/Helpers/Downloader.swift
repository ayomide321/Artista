//
//  Downloader.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/21/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import Foundation
import FirebaseStorage

//let storage = Storage.storage()

func uploadImages(images: [UIImage?], itemID: String, completion: @escaping (_ imageLinks: [String]) -> Void) {
    
    if Reachabilty.HasConnection() {
        
    } else {
        print("No Internet Connection")
        //TODO: Show user that there is no internet
    }
}
