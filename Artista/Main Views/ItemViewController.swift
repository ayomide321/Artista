//
//  ItemViewController.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/23/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit
import JGProgressHUD

class ItemViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    //MARK: - Variables
    var item: Item!
    var itemImages: [UIImage] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    
    
    //MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


    }
    


}
