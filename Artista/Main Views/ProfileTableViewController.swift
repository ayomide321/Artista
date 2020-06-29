//
//  ProfileTableViewController.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/29/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    
    //MARK: - IBOutlets
    
    @IBOutlet weak var finishRegistrationButtonOutlet: UIButton!
    @IBOutlet weak var purchaseHistoryBurronOutlet: UIButton!
    
    //MARK: - Vars
    var editBarButtonOutlet: UIBarButtonItem!
    
    //MARK: - view Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkLoginStatus()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3
    }
    
    //MARK: - Helpers
    
    private func checkLoginStatus() {
        
        if MUser.currentUser() == nil {
            createRightBarButton(title: "Login")
        } else {
            createRightBarButton(title: "Edit")
        }
    }
    
    private func createRightBarButton(title: String) {
        
        editBarButtonOutlet = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(rightBarButtonItemPressed))
        
        self.navigationItem.rightBarButtonItem = editButtonItem
    }
    
    //MARK: - IBActions
    
    @objc func rightBarButtonItemPressed() {
        
        if editButtonItem.title == "Login" {
            //SHOW LOGIN VIEW
        } else {
            //go to profile info
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        
    }
    

}
