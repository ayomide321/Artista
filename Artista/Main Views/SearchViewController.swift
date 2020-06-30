//
//  SearchViewController.swift
//  Artista
//
//  Created by Ayo Kuye on 6/30/20.
//  Copyright © 2020 Ayomide Omolewa. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchOptionView: UIView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var searchButtonOutlet: UIView!
    
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
       
    }
    
    //MARK: IBActions
    
    @IBAction func showSearchBarButton(_ sender: Any) {
    }
    @IBAction func searchButtonPressed(_ sender: Any) {
    }
    
    
    //MARK: - Helpers
    
    private func emptyTextField() {
        searchTextField.text = ""
    }

    private func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    @objc func textFieldDidChange (_ textField: UITextField) {
        
        print("typing")
        searchButtonOutlet.isUserInteractionEnabled = textField.text != ""
        
        if searchButtonOutlet.isUserInteractionEnabled {
            searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        } else {
            disableSearchButton()
            
        }
    }
    
    private func disableSearchButton() {
        searchButtonOutlet.isUserInteractionEnabled = false
        searchButtonOutlet.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
    }
    
    
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    
}
