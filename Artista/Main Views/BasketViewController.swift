//
//  BasketViewController.swift
//  Artista
//
//  Created by Ayomide Omolewa on 6/28/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit
import JGProgressHUD
import Stripe
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
    var totalPriceBeforeFee = 0
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
        
        if MUser.currentUser()!.onBoard {
            
            tempFunction()
            showPaymentOptions()
            addItemstoPurchaseHistory(self.purchasedItemIDs)
            emptyTheBasket()
            
        
        } else {
            
            self.showNotification(text: "Please complete your profile", isError: true)
            
        }
        
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
    
    
    func tempFunction() {
        for item in allItems {
            
            purchasedItemIDs.append(item.id)
        }
    }
    
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
    
    private func emptyTheBasket() {
        
        purchasedItemIDs.removeAll()
        allItems.removeAll()
        tableView.reloadData()
        
        basket!.itemIDs = []
        
        updateBasketInFirestore(basket!, withValues: [kITEMIDS : basket!.itemIDs]) { (error) in
            
            if error != nil {
                print("Error updating basket", error!.localizedDescription)
            }
            self.getBasketItems()
        }
        
    }
    
    private func addItemstoPurchaseHistory(_ itemIds: [String]) {
        
        if MUser.currentID() != nil {
            
            let newItemIds = MUser.currentUser()!.purchasedItemIds + itemIds
            
            updateCurrentUserInFirestore(withValues: [kPURCHASEITEMIDS : newItemIds]) { (error) in
                if error != nil {
                    print("Error adding purchased items ", error?.localizedDescription)
                }
                
            }
                
        }
    }
    
    private func applyFee(_cost: Double) -> Double {
        var additionCost: Double = 0
        var finalFee: Double = 0
        if _cost <= 5000 {
            return (_cost * 1.16)
        }
        if _cost > 5000 && _cost <= 20000 {
            additionCost = _cost - 5000
            finalFee = additionCost * 1.14 + (5000 * 1.16)
        }
        if _cost > 20000 {
            additionCost = _cost - 20000
            
        }
        
        return finalFee
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
    
    //PAYPAL
    private func finishPayment(token: STPToken) {
        self.totalPriceBeforeFee = 0
        
        for item in allItems {
            purchasedItemIDs.append(item.id)
            self.totalPriceBeforeFee += Int(item.price)
        }
        
        self.totalPriceBeforeFee = self.totalPriceBeforeFee * 100
        
        StripeClient.sharedClient.createAndConfirmPayment(token, amount: totalPriceBeforeFee) { (error) in
            if error == nil {
                self.emptyTheBasket()
                self.addItemstoPurchaseHistory(self.purchasedItemIDs)
                self.showNotification(text: "Payment successful", isError: false)
            } else {
                print("Error: ", error!.localizedDescription)
            }
        }
    }
    
    private func showNotification(text: String, isError: Bool) {
        if isError{
            self.hud.indicatorView = JGProgressHUDErrorIndicatorView()
        } else {
            self.hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        }
        
        self.hud.textLabel.text = text
        self.hud.show(in: self.view)
        self.hud.dismiss(afterDelay: 2.0)
    }
    
    private func showPaymentOptions() {
        
        let alertController = UIAlertController(title: "Payment Options", message: "Choose prefered payment option", preferredStyle: .actionSheet)
        
        let cardAction = UIAlertAction(title: "Pay with card", style: .default) { (action) in
            
            //Show card number view
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cardAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
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
