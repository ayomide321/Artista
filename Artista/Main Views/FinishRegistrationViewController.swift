//
//  FinishRegistrationViewController.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/29/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit
import JGProgressHUD

class FinishRegistrationViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var doneButtonOutlet: UIButton!
    
    //MARK: - Variables
    let hud = JGProgressHUD(style: .dark)
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        nameTextField.addTarget(self, action: #selector(self.textFieldDidchange(_:)), for: UIControl.Event.editingChanged)
        lastnameTextField.addTarget(self, action: #selector(self.textFieldDidchange(_:)), for: UIControl.Event.editingChanged)
        addressTextField.addTarget(self, action: #selector(self.textFieldDidchange(_:)), for: UIControl.Event.editingChanged)

    }
    
    //MARK: - IBActions
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        finishOnboarding()
    
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }
    
    //
    @objc func textFieldDidchange(_ textField: UITextField) {
        
        updateDoneButtonStatus()
    }
    
    //MARK: - Helper
    private func updateDoneButtonStatus() {
        
        if nameTextField.text != "" && lastnameTextField.text != "" && addressTextField.text != "" {
            
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
            doneButtonOutlet.isEnabled = true
        } else {
            doneButtonOutlet.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
            doneButtonOutlet.isEnabled = false
        }
        
    }
    
    private func finishOnboarding() {
        
        let withValues = [kFIRSTNAME : nameTextField.text!, kLASTNAME : lastnameTextField.text!, kONBOARD : true, kFULLADDRESS : addressTextField.text!, kFULLNAME : (nameTextField.text! + " " + lastnameTextField.text!)] as [String:Any]
        updateCurrentUserInFirestore(withValues: withValues) { (error) in
            
            if error == nil {
                self.hud.textLabel.text = "Registration Complete!"
                self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)
                
                self.dismiss(animated: true, completion: nil)
            } else {
                
                print("error updating user \(error!.localizedDescription)")
                
                self.hud.textLabel.text = error!.localizedDescription
                self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
                self.hud.show(in: self.view)
                self.hud.dismiss(afterDelay: 2.0)            }
        }
    }
    
}
