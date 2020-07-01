//
//  CategoryCollectionViewCell.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/9/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    func generateCell(_ category: Category) {
        
        nameLabel.text = category.name
        imageView.image = category.image
        
    }
    
}
