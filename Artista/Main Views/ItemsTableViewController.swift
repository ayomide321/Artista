//
//  ItemsTableViewController.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/9/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit

class ItemsTableViewController: UITableViewController {

    //Mark: Variables
    var category: Category?
    
    var itemArray: [Item] = []
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        self.title = category?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if category != nil {
            loadItems()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(itemArray[indexPath.row])

        return cell
    }
    
    
    // MARK: - Navigation


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemToAddItemSeg" {
        
            let vc = segue.destination as! AddItemViewController
            vc.category = category!
        }
    }
    
    //MARK: Load Items
    private func loadItems() {
        downloadItemsFromFirebase(category!.id) { (allItems) in
            
            self.itemArray = allItems
            self.tableView.reloadData()
        }
        
    }
    

}
