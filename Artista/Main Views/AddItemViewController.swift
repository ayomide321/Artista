//
//  AddItemViewController.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/17/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit
import Gallery
import JGProgressHUD
import NVActivityIndicatorView

class AddItemViewController: UIViewController {

    //MARK: IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextview: UITextView!
    
    //MARL: Variables
    var category: Category!
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    
    var activityIndicator: NVActivityIndicatorView?
    
    var itemImages: [UIImage?] = []
    	
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: IBActions
    
    @IBAction func doneBarButtonItemPressed(_ sender: Any) {
        dismissKeyboard()
        if fieldsAreCompleted() {
            saveToFirebase()
            //TODO: Add item to categories
        } else {
            print("Error: All Fields must be completed")
            //TODO: Show error to user
        }
        
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        
        itemImages = []
        showImageGallery()
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        dismissKeyboard()
    }
    
    //MARK: Helper functions
    
    private func fieldsAreCompleted() -> Bool {
        
        return (titleTextField.text != "" && priceTextField.text != "" && descriptionTextview.text != "")
    }
    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    private func popTheView() {
        
        self.navigationController?.popViewController(animated: true)
    }
    //MARK: Save Item
    private func saveToFirebase() {
        let item = Item()
        item.id = UUID().uuidString
        item.name = titleTextField.text!
        item.categoryID = category.id
        item.description = descriptionTextview.text
        item.price = Double(priceTextField.text!)
        
        //if there is atleast one image
        if itemImages.count > 0 {

            
        } else {
            //no images to save
            saveItemToFireStore(item)
            popTheView()
            
        }
        
    }
    
    //MARK: Show Gallery
    private func showImageGallery() {
        
        self.gallery = GalleryController()
        self.gallery.delegate = self
        
        Config.tabsToShow = [.imageTab, .cameraTab]
        Config.Camera.imageLimit = 6
        
        self.present(self.gallery, animated: true, completion: nil)
        
        
    }
}


extension AddItemViewController: GalleryControllerDelegate {
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        
        if images.count > 0 {
            
            Image.resolve(images: images) { (resolvedImages) in
                
                self.itemImages = resolvedImages
            }
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
