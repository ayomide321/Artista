//
//  WelcomeViewController.swift
//  Artista
///
//  Created by Ayo Kuye on 6/27/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit
import JGProgressHUD
import NVActivityIndicatorView

class WelcomeViewController: UIViewController {
    
    
    //MARK: IBOutlets
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBOutlet weak var resendButtonOutlet: UIButton!
    
    //MARK: - Vars
    
    let hud = JGProgressHUD(style: .dark)
    var activityIndicator: NVActivityIndicatorView?
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 30, width: 60.0, height: 60.0), type: .ballPulse, color: #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1), padding: nil)
    }
    

    
    //MARK: IBActions
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dissmissView()
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("login")
        
        
    }
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        print("register")
        
        if textFieldsHaveText() {
            
            registerUser()
        } else {
            hud.textLabel.text = "All Field are Required"
            hud.indicatorView = JGProgressHUDErrorIndicatorView()
            hud.show(in: self.view)
            hud.dismiss(afterDelay: 2.0)
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        print("forgot password")
        
    }
    
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        print("resend email")
        
    }
    
    //MARK: - Register User
    
    private func registerUser() {
        
        showLoadingIndicator()
    
    }
    
    
    //MARK: - Helpers
    
    private func textFieldsHaveText() ->Bool {
        return (emailTextField.text != "" && passwordTextField.text != "")
    }
    
    private func dissmissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Activity Indicator
    
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
}