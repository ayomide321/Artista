//
//  WelcomeViewController.swift
//  Artista
//
//  Created by Ayo Kuye on 6/24/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var resendButtonOutlet: UIButton!
    

    //MARK: - View Lifecycle
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: - IBActions
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        print("cancel")
        
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("login")
        
        
    }
    @IBAction func registerButton(_ sender: Any) {
        print("register")
        
        
    }
    
    @IBAction func forgotPasswordButton(_ sender: Any) {
        print("forgot")
        
        
    }
    
    @IBAction func resendEmailPressed(_ sender: Any) {
        print("resend")
        
        
    }
}
