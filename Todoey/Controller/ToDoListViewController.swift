//
//  ViewController.swift
//  Todoey
//
//  Created by Sandip Mahajan on 27/12/18.
//  Copyright © 2018 RAMAppBrewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let item1 = Item()
        item1.title = "Grocery"
        itemArray.append(item1)
        
        let item2 = Item()
        item2.title = "Work"
        itemArray.append(item2)
        
        let item3 = Item()
        item3.title = "Personal"
        itemArray.append(item3)
        
        
        if let items = defaults.array(forKey: "ToDoItemArray") as? [Item]
        {
            itemArray = items
        }

    }
    
    //MARK: Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    
    //MARK: Tableview Delegate Methods
    
  override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    
        if itemArray[indexPath.row].done == true
        {
           tableView.cellForRow(at: indexPath)?.accessoryType = .none
           itemArray[indexPath.row].done = !(itemArray[indexPath.row].done)!
            
        }
       else
        {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            itemArray[indexPath.row].done = !(itemArray[indexPath.row].done)!
        }
    
       tableView.deselectRow(at: indexPath, animated: true)
    
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var txtField : UITextField!
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            (alertAction) in
            
            let item = Item()
            item.title = txtField.text!
            
           self.itemArray.append(item)
            
          self.defaults.set(self.itemArray, forKey: "ToDoItemArray")
            
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

