//
//  EditItemViewController.swift
//  Artista
//
//  Created by Ayomide Omolewa on 7/1/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit
import JGProgressHUD

class EditItemViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    
    //MARK: - IBActions
    @IBAction func doneButtonPressed(_ sender: Any) {
        dismissKeyboard()
        
        if fieldsAreCompleted() {
            let withValues = [kNAME: nameTextField.text!, kPRICE: priceInCurrency, kDESCRIPTION : descriptionTextField.text!] as [String : Any]
            updateCurrentItemInFirestore(item, withValues: withValues) { (error) in
                    
                    if error == nil {
                        self.hud.textLabel.text = "Item was updated!"
                        self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                        self.hud.show(in: self.view)
                        self.hud.dismiss(afterDelay: 2.0)
                    } else {
                        self.hud.textLabel.text = error!.localizedDescription
                        self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                        self.hud.show(in: self.view)
                        self.hud.dismiss(afterDelay: 2.0)                }
                }
            } else {
                self.hud.textLabel.text = "All fields must be completed and item must be atleast $1!"
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
            }
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Variables
    
    let hud = JGProgressHUD(style: .dark)
    var priceInCurrency: Int = 0
    var itemImages: [UIImage] = []
    var item: Item!
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        loadItemInfo()
        
        priceTextField.delegate = self
        priceTextField.placeholder = updateAmount()
        
    }
    
    //MARK: - Update UI
    private func loadItemInfo() {
        
        if MUser.currentUser() != nil{
            nameTextField.text = item!.name
            priceTextField.text = updateAmount()
            descriptionTextField.text = item!.description
        }
    }
    
    //MARK: Helper functions
    
    private func fieldsAreCompleted() -> Bool {
        
        let firstVar: Bool = (nameTextField.text != "" && priceTextField.text != "" && descriptionTextField.text != "")
        let secondVar: Bool = (priceInCurrency >= 100 && priceInCurrency <= 9999999)
        return (firstVar && secondVar)
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
    
    
    

}
