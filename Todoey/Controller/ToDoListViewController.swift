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
    
    let filePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("items.plist")
    
    let encoder = PropertyListEncoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()

    }
    
    //MARK: Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    
    //MARK: Tableview Delegate Methods
    
  override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
       let item = itemArray[indexPath.row]
    
       tableView.cellForRow(at: indexPath)?.accessoryType = item.done ? .none : .checkmark
    
       item.done = !item.done
    
       saveItems()
    
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
            
           self.saveItems()
            
            }
    
        alert.addAction(action)
        
        alert.addTextField {
            
            (textField) in
            
            textField.placeholder = "Create New Item"
            txtField = textField
            
        }
    
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: filePath!)
        }
        catch{
            print("Error encoding data \(error)")
        }
        
        //   self.defaults.set(self.itemArray, forKey: "ToDoItemArray")
        
        self.tableView.reloadData()
    }
    
    func loadData() {
        
        do {
          let data = try Data(contentsOf: filePath!)
          let decoder = PropertyListDecoder()
          itemArray = try decoder.decode([Item].self, from: data)
        }
        catch {
            print("Error loading data \(error)")
        }
        
    }
}

