//
//  WelcomeViewController.swift
//  Artista
///
//  Created by Ayo Kuye on 6/27/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    
    //MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var resendButtonOutlet: UIButton!
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    //MARK: IBActions
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        print("cancel")
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("login")
        
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        print("register")
        
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        print("forgot password")
        
    }
    
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        print("resend email")
        
    }
}
