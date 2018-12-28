//
//  ViewController.swift
//  Todoey
//
//  Created by Sandip Mahajan on 27/12/18.
//  Copyright © 2018 RAMAppBrewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Grocery", "Work", "Personal"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    
    //MARK: Tableview Delegate Methods
    
  override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark
        {
           tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
       else
        {
        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    
       tableView.deselectRow(at: indexPath, animated: true)
    
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var txtField : UITextField!
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (alertAction) in
            
           self.itemArray.append(txtField.text!)
            
           self.tableView.reloadData()
            }
        
        
        
        alert.addAction(action)
        
        alert.addTextField {
            
            (textField) in
            
            textField.placeholder = "Create New Item"
            txtField = textField
            
        }
    
        
        present(alert, animated: true, completion: nil)
    }
    
}

