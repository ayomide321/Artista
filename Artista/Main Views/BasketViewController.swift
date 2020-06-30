//
//  BasketViewController.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/28/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit
import JGProgressHUD

class BasketViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var checkOutButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var basketTotalPriceLabel: UILabel!
    
    //MARK: - Variables
    var basket: Basket?
    var allItems: [Item] = []
    var purchasedItemIDs : [String] = []
    
    let hud = JGProgressHUD(style: .dark)
    
    //MARK: - View Lifecycle
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = footerView

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if MUser.currentUser() != nil {
            loadBasketFromFirestore()
        } else {
            self.updateTotalLabels(true)
        }
    }
    

    //MARK: - IBActions
    
    @IBAction func checkoutButtonPressed(_ sender: Any) {
        
        
    }
    
    //MARK: - Download basket
    private func loadBasketFromFirestore() {
        
        downloadBasketFromFirestore(MUser.currentID()) { (basket) in
            
            self.basket = basket
            self.getBasketItems()
        }
    }
    
    private func getBasketItems() {
        
        if basket != nil {
            
            downloadItems(basket!.itemIDs) { (allItems) in
                
                self.allItems = allItems
                self.updateTotalLabels(false)
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: Helper functions
    
    private func updateTotalLabels(_ isEmpty: Bool) {
        
        if isEmpty {
            totalItemsLabel.text = "0"
        } else {
            totalItemsLabel.text = "\(allItems.count)"
        }
        basketTotalPriceLabel.text = returnBasketTotalPrice()
        
        checkoutButtonStatusUpdate()
    }
    
    private func returnBasketTotalPrice() -> String {
        
        var totalPrice = 0.0
        
        for item in allItems {
            totalPrice += item.price
        }
        return "Total Price: " + convertToCurrency(totalPrice)
    }
    
    //MARK: - Navigation
    
    private func showItemView(withItem: Item) {
        
        let itemVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "itemView") as! ItemViewController
        itemVC.item = withItem
        self.navigationController?.pushViewController(itemVC, animated: true)
        
    }
    
    //MARK: - Control checkoutButton
    private func checkoutButtonStatusUpdate() {
        
        checkOutButtonOutlet.isEnabled = allItems.count > 0
        
        if checkOutButtonOutlet.isEnabled {
            
            checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        } else {
            disableCheckoutButton()
        }
        
    }
    
    private func disableCheckoutButton() {
        checkOutButtonOutlet.isEnabled = false
        checkOutButtonOutlet.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
    }
    
    private func removeItemFromBasket(itemID: String) {
        
        for i in 0..<basket!.itemIDs.count {
            
            if itemID == basket!.itemIDs[i] {
                basket!.itemIDs.remove(at: i)
                
                return
            }
        }
    }
    
}


extension BasketViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ItemTableViewCell
        
        cell.generateCell(allItems[indexPath.row])
        return cell
    }
    
    //MARK: - UITableView Delegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let itemToDelete = allItems[indexPath.row]
            
            allItems.remove(at: indexPath.row)
            tableView.reloadData()
            removeItemFromBasket(itemID: itemToDelete.id)
            
            updateBasketInFirestore(basket!, withValues: [kITEMIDS: basket!.itemIDs]) { (error) in
                
                if error != nil {
                    print ("Error: Update basket function could not be completed", error!.localizedDescription)
                }
                
                self.getBasketItems()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        showItemView(withItem: allItems[indexPath.row])
        
    }
    
}
