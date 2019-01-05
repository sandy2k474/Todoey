//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sandip Mahajan on 01/01/19.
//  Copyright © 2019 RAMAppBrewery. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
   var categoryItems: Results<Category>?
   var selectedCategory = Category()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryItems?[indexPath.row].title ?? "No Categories Found"
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = (categoryItems?[indexPath.row])!
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! ToDoListViewController
        destinationVC.parentCategory = selectedCategory
    }
    
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField: UITextField?
        
        let alertController = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) {
            
            (alertAction) in
            
            let category = Category()
            
            category.title = (textField?.text!)!
            
            self.save(category: category)
            
            self.tableView.reloadData()
        }
        
        alertController.addAction(action)
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Category"
            textField = alertTextField
        }
        
      
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving data using Realm \(error)")
        }
    }
    
    func loadCategories() {

        categoryItems = realm.objects(Category.self).sorted(byKeyPath: "title")
        tableView.reloadData()
        
    }
    
}
