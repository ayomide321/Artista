//
//  SellHistoryTableViewController.swift
//  Artista
//
//  Created by Ayomide Omolewa on 7/1/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class SellHistoryTableViewController: UITableViewController {
    
    //MARK: - Vars
    var itemArray: [Item] = []
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self

       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadItems()
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
  
    
    
    //MARK: - Load Items
    
    
    private func loadItems() {
        
        downloadItems(MUser.currentUser()!.soldItemIds) { (allItems) in
            
            self.itemArray = allItems
            print("we have \(allItems.count) sold items")
            self.tableView.reloadData()
        }
    }

}


extension SellHistoryTableViewController: EmptyDataSetSource, EmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "No items purchased!")
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        
        return UIImage(named: "emptyData")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        
        return NSAttributedString(string: "Please check back later")
    }
    
}
