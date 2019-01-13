//
//  ViewController.swift
//  Todoey
//
//  Created by Sandip Mahajan on 27/12/18.
//  Copyright © 2018 RAMAppBrewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
   // let searchController = UISearchController(searchResultsController: nil)
    
    let realm = try! Realm()

    var todoItems: Results<Item>?
    var allItems : Results<Item>?
    var parentCategory: Category? {
        didSet {
            loadData()
            allItems = todoItems
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
     //   navigationItem.searchController = searchController
     //   navigationItem.hidesSearchBarWhenScrolling = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard let selectedCategory = parentCategory else {
            fatalError()
        }
        
        title = selectedCategory.title
    
        updateNavigationBar(withHexCode: selectedCategory.backgroundColour)
        
        searchBar.layer.borderWidth = 5
        searchBar.layer.borderColor = UIColor(hexString: selectedCategory.backgroundColour)?.cgColor
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavigationBar(withHexCode: "1D9BF6")
    }
    
    
    //MARK:- Update Navigation Bar
    func updateNavigationBar(withHexCode colourCode: String) {
        
        guard let navigationBar = navigationController?.navigationBar else {
            fatalError()
        }
        
        guard let colour = UIColor(hexString: colourCode) else {
            fatalError()
        }
        
        navigationBar.barTintColor = colour
        navigationBar.tintColor = ContrastColorOf(colour, returnFlat: true)
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(colour, returnFlat: true)]
        
        searchBar.barTintColor = colour
        
        searchBar.isTranslucent = true
        
    }
    
    //MARK: Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let currentItem = todoItems?[indexPath.row] {
        
        cell.textLabel?.text = currentItem.title
        cell.accessoryType = currentItem.done ? .checkmark : .none
            
        //cell.textLabel?.font = UIFont(name: "Menlo", size: 20)
            
            if let font = UserDefaults.standard.string(forKey: "font") {
                
               cell.textLabel?.font = UIFont(name: font, size: 20)
            }
            
        let percent = CGFloat(indexPath.row + 1)/CGFloat(todoItems!.count)
           // print("Darken Percentage: \(percent)")
        
        guard let categoryColour = UIColor(hexString: parentCategory!.backgroundColour) else { fatalError() }
            
         cell.backgroundColor = categoryColour.darken(byPercentage: percent)
            
          cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
        //Set tint colour for the accessory types
        cell.tintColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            
        }
        else
        {
            cell.textLabel?.text = "No Items Found"
        }
        
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
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) {
            
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
        
         let dismissAction = UIAlertAction(title: "Cancel", style: .default) {
            
            (alertAction) in
            
            self.dismiss(animated: true, completion: nil)
        }
    
            alert.addAction(addAction)
            alert.addAction(dismissAction)

            alert.preferredAction = addAction
        
            alert.addTextField {
            
            (alertTextField) in
            
            alertTextField.placeholder = "Create a New Item"
            alertTextField.autocorrectionType = .yes
            alertTextField.autocapitalizationType = .words
            txtField = alertTextField
            
        }
    
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadData() {
        
          todoItems = parentCategory?.items.sorted(byKeyPath: "done", ascending: true)
          tableView.reloadData()
    }
    
    func loadData(with predicate: NSPredicate) {
        
        
        todoItems = allItems?.filter(predicate).sorted(byKeyPath: "done", ascending: true)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            
            delete(item: itemForDeletion)
            
        }
    }
    
    func delete(item: Item) {
        do {
            try realm.write {
                realm.delete(item)
            }
        }
        catch {
            print("Error deleting data using Realm \(error)")
        }
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
