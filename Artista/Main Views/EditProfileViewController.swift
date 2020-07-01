//
//  EditProfileViewController.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/29/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit
import JGProgressHUD

class EditProfileViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    
    //MARK: - Variables

    let hud = JGProgressHUD(style: .dark)
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    //MARK: - IBActions
    
    @IBAction func saveBarButtonPressed(_ sender: Any) {
        
        dismissKeyboard()
        
        if textFieldsHaveText() {
            
            let withValues = [kFIRSTNAME : nameTextField.text!, kLASTNAME : lastnameTextField.text!, kFULLNAME : (nameTextField.text! + " " + lastnameTextField.text!), kFULLADDRESS : addressTextField.text!]
            updateCurrentUserInFirestore(withValues: withValues) { (error) in
                
                if error == nil {
                    self.hud.textLabel.text = "Profile was updated!"
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
            self.hud.textLabel.text = "All fields must be completed!"
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
            self.hud.show(in: self.view)
            self.hud.dismiss(afterDelay: 2.0)
            
        }
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        logOutUser()
    }
    
    
    //MARK: - UpdateUI
    private func loadUserInfo() {
        
        if MUser.currentUser() != nil {
            let currentUser = MUser.currentUser()!
            
            nameTextField.text = currentUser.firstName
            lastnameTextField.text = currentUser.lastName
            addressTextField.text = currentUser.fullAddress
            
        }
    }
    
    //MARK: - Helper Functions
    private func dismissKeyboard() {
        
        self.view.endEditing(false)
    }
    
    private func textFieldsHaveText() -> Bool {
        
        return (nameTextField.text != "" && lastnameTextField.text != "" && addressTextField.text != "")
    }
    
    
    private func logOutUser() {
        MUser.logOutCurrentUser { (error) in
            
            if error == nil {
                print("logged out")
                self.navigationController?.popViewController(animated: true)
            }  else {
                print("error login out", error!.localizedDescription)
            }
        }
        
    }
    
    //MARK: - Delete Function
    private func deleteItem() {
        
        
        
    }
}
