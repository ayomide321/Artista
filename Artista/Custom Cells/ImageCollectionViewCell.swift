//
//  ImageCollectionViewCell.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/25/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    func setupImageWith(itemImage: UIImage) {
        
        imageView.image = itemImages
    }
    
}
