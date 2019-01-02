//
//  ViewController.swift
//  Todoey
//
//  Created by Sandip Mahajan on 27/12/18.
//  Copyright © 2018 RAMAppBrewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    var parentCategory: Category? {
        didSet {
            loadData()
        }
    }
    let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        


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
    
       item.done = !item.done
    
       saveItems()
    
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var txtField : UITextField!
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) {
            
            (alertAction) in
            
            let item = Item(context: self.viewContext)
            item.title = txtField.text!
            item.done = false
            item.parentCategory = self.parentCategory
            
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
            try viewContext.save()
        }
        catch{
            print("Error saving context  \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), itemPredicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.title MATCHES %@", (parentCategory?.title)!)
        
        if let inputPredicate = itemPredicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, inputPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        do {
          itemArray = try viewContext.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }

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
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let itemPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request, itemPredicate: itemPredicate)
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
    }
    
}
