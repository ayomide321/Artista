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

class AddItemViewController: UIViewController, UITextFieldDelegate {

    //MARK: IBOutlets
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextview: UITextView!
    
    //MARL: Variables
    var category: Category!
    var gallery: GalleryController!
    let hud = JGProgressHUD(style: .dark)
    var priceInCurrency: Int = 0
    var activityIndicator: NVActivityIndicatorView?
    
    var itemImages: [UIImage?] = []
    	
    //MARK: View lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        priceTextField.delegate = self
        priceTextField.placeholder = updateAmount()

    }
        		
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        activityIndicator = NVActivityIndicatorView (frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60, height: 60), type: .lineSpinFadeLoader, color: #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1), padding: nil)
        
    }
    //MARK: IBActions
    
    @IBAction func doneBarButtonItemPressed(_ sender: Any) {
        dismissKeyboard()
        if fieldsAreCompleted() {
            saveToFirebase()
            //TODO: Add item to categories
        } else {
            
            self.hud.textLabel.text = "All fields are required!"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
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
    
    private func updateAmount() -> String? {
        
        let formatter = NumberFormatter()
        
        formatter.numberStyle = NumberFormatter.Style.currency
        
        let amount = Double(priceInCurrency/100) + Double(priceInCurrency%100)/100
        
        return formatter.string(from: NSNumber(value: amount))
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let digit = Int(string) {
            
            priceInCurrency = priceInCurrency * 10 + digit
            
            priceTextField.text = updateAmount()
        }
        
        if string == "" {
            
            priceInCurrency /= 10
            
            priceTextField.text = updateAmount()
            
        }
        
        return false
    }
    //MARK: Save Item
    private func saveToFirebase() {
        
        showLoadingIndicator()
        
        let item = Item()
        item.id = UUID().uuidString
        item.name = titleTextField.text!
        item.categoryID = category.id
        item.description = descriptionTextview.text
        item.price = Double(priceInCurrency/100)
        
        //if there is atleast one image
        if itemImages.count > 0 {
            
            uploadImages(images: itemImages, itemId: item.id) { (imageLinkArray) in
                item.imageLinks = imageLinkArray
                saveItemToFireStore(item)
                saveItemToAlgolia(item: item)
                self.hideLoadingIndicator()
                self.popTheView()
            }
            
        } else {
            //no images to save
            saveItemToFireStore(item)
            saveItemToAlgolia(item: item)
            popTheView()
            
        }
        
    }
    
    //MARK: Activity Indicator
    
    private func showLoadingIndicator() {
        
        if activityIndicator != nil {
            self.view.addSubview(activityIndicator!)
            activityIndicator!.startAnimating()
        }
        
    }
    
    private func hideLoadingIndicator() {
        
        if activityIndicator != nil {
            activityIndicator!.removeFromSuperview()
            activityIndicator!.stopAnimating()
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
