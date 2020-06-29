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
    
    
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
    
        self.dismiss(animated: true, completion: nil)
    }
    
    //
    @objc func textFieldDidchange(_ textField: UITextField) {
        
        print("Text field did change")
    }
    
}
