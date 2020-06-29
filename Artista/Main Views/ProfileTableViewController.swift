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
    
    //MARK: - view Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //check logged in status
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 3
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    

}
