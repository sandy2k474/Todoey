//
//  ViewController.swift
//  Todoey
//
//  Created by Sandip Mahajan on 27/12/18.
//  Copyright © 2018 RAMAppBrewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    let realm = try! Realm()

    var todoItems: Results<Item>?
    var parentCategory: Category? {
        didSet {
            self.title = parentCategory?.title
            loadData()
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = todoItems?[indexPath.row].title ?? "No Items Found"
        cell.accessoryType = todoItems?[indexPath.row].done ?? false ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    
    //MARK: Tableview Delegate Methods
    
  override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
       let item = todoItems![indexPath.row]
    
    do{
        try realm.write {
            item.done = !item.done
        }
    }
    catch
    {
        print("Error toggling item state \(error)")
    }
    
    tableView.reloadData()
    
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var txtField : UITextField!
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            
            (alertAction) in
            
            do {
           
                let item = Item()
                item.title = txtField.text!
                
                try self.realm.write {
                    self.parentCategory?.items.append(item)
                }
            }
            catch {
                
                print("Error adding items to category \(error)")
            }
            
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
    
    
    func loadData() {
        
          todoItems = parentCategory?.items.sorted(byKeyPath: "title", ascending: true)
          tableView.reloadData()
    }
    
    func loadData(with predicate: NSPredicate) {
        
        todoItems = todoItems?.filter(predicate).sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        if(searchBar.text?.count == 0)
        {
            loadData()
        }
        else {

         let itemPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
         loadData(with: itemPredicate)
        }

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if(searchBar.text?.count == 0)
        {
              loadData()

             DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        else {
            let itemPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
            loadData(with: itemPredicate)
        }
    }
}
