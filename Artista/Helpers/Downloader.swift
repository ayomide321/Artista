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



func saveImageInFirebase(imageData: Data, fileName: String, completion: @escaping (_ imageLink: String?) -> Void) {
    
    var task: StorageUploadTask!
    
    let storageRef = storage.reference(forURL: kFILEREFERENCE).child(fileName)
    
    task = storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
        
        task.removeAllObservers()
        
        if error != nil {
            print("Error uploading image", error!.localizedDescription)
            completion(nil)
            return
        }
        
        storageRef.downloadURL { (url, error) in
            
            guard let downloadUrl = url else {
                completion(nil)
                return
            }
            
            completion(downloadUrl.absoluteString)
        }
    })
}

func downloadImages(imageUrls: [String], completion: @escaping (_ images: [UIImage?]) -> Void) {
    
    var imageArray: [UIImage] = []
    
    var downloadCounter = 0
    
    for link in imageUrls {
        
        let url = NSURL(string: link)
        
        let downloadQueue = DispatchQueue(label: "imageDownloadqueue")
        
        downloadQueue.async {
            downloadCounter += 1
            
            let data = NSData(contentsOf: url! as URL)
            
            if data != nil {
                
                imageArray.append(UIImage(data: data! as Data)!)
                
                if downloadCounter == imageArray.count {
                    DispatchQueue.main.async {
                        completion(imageArray)
                    }
                }
                
            } else {
                print("couldn't download image")
                completion(imageArray)
            }
        }
        
    }
}
