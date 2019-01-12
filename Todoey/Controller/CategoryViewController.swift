//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sandip Mahajan on 01/01/19.
//  Copyright © 2019 RAMAppBrewery. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework


class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
   var categoryItems: Results<Category>?
   var selectedCategory = Category()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 80
        
        tableView.separatorStyle = .none
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        
       loadCategories()
    }
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryItems?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! CustomCategoryCell
        
        if let currentCategory = categoryItems?[indexPath.row] {
            
       // cell.textLabel?.font = UIFont(name: "Menlo", size: 25.5)
        
            if let font = UserDefaults.standard.string(forKey: "font") {
            
          cell.textLabel?.font = UIFont(name: font, size: 23)
            }
        
        cell.textLabel?.text = currentCategory.title
       
//       cell.title.font = UIFont(name: "Menlo", size: 25.5)
//
//       cell.title.text = currentCategory.title

        cell.backgroundColor = UIColor(hexString: currentCategory.backgroundColour)
       
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            
//      cell.title.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        
      //  let predicate = NSPredicate(format: "parentCategory CONTAINS %@", currentCategory.title)
            
        let numberOfItems = realm.objects(Item.self).filter("ANY parentCategory.title == %@", "\(currentCategory.title)").count
        
        // print(numberOfItems)
            
        cell.numberOfItems.text = "\(numberOfItems)"
            
        if let font = UserDefaults.standard.string(forKey: "font") {
            cell.numberOfItems.font = UIFont(name: font, size: 23)
            }
            
        cell.numberOfItems.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            
        //Set tint colour for the accessory types
        cell.tintColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            
        }
        else {
        //cell.textLabel?.text = "No Categories Found"
            
        cell.title.text = "No Categories Found"
        }
        
        
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
        
        let alertController = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) {
            
            (alertAction) in
            
            if !((textField?.text ?? "").isEmpty)  {
            
            let category = Category()
            
            category.title = textField!.text!
                
            let categoryColour = RandomFlatColor().hexValue()
            print("Category Colour: " + categoryColour)
            category.backgroundColour = categoryColour
            
            self.save(category: category)
            
            self.tableView.reloadData()
            }
            else {
              self.invalidCategory()
            }
        }
        
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .default) {
            
            (alertAction) in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(addAction)
        alertController.addAction(dismissAction)
        
        alertController.preferredAction = addAction
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "e.g. Grocery, Work etc"
            alertTextField.autocorrectionType = .yes
            alertTextField.autocapitalizationType = .words
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
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categoryItems?[indexPath.row] {

            delete(category: categoryForDeletion)

        }
    }
    
    func delete(category: Category) {
        do {
            try realm.write {
                realm.delete(category)
            }
        }
        catch {
            print("Error deleting data using Realm \(error)")
        }
    }
    
    func loadCategories() {

        categoryItems = realm.objects(Category.self).sorted(byKeyPath: "title")
        tableView.reloadData()
        
    }
    
    //MARK:- More Actions Such as Editing the Category Name, Location Based Services etc.
    
    override func moreActions(at indexPath: IndexPath) {
        
        guard let category = self.categoryItems?[indexPath.row] else { fatalError() }
        
        var textField: UITextField?
        
        let alertController = UIAlertController(title: "Edit Category", message: "", preferredStyle: .alert)
        
        let editAction = UIAlertAction(title: "Modify", style: .default) {
            
            (alertAction) in
            
            if !(textField?.text ?? "").isEmpty {
            
            self.update(category: category, newTitle: textField!.text!)
            
            self.tableView.reloadData()
            }
            else {
                
            self.invalidCategory(at: indexPath)
                
            }
        }
        
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .default) {
            
            (alertAction) in
            
            self.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }
        
        alertController.addAction(editAction)
        alertController.addAction(dismissAction)
        
        alertController.preferredAction = editAction
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = category.title
            textField = alertTextField
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    func invalidCategory(at indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "Please enter a valid category name", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) {
            (alertAction) in
            
            self.moreActions(at: indexPath)
        }
        
        alertController.addAction(okAction)
        alertController.preferredAction = okAction
        
         present(alertController, animated: true, completion: nil)
    }
    
    func update(category: Category, newTitle: String) {
        
        do {
            try realm.write {
                category.title = newTitle
            }
        }
        catch {
            print("Error Updating data using Realm \(error)")
        }
    }
    
    func invalidCategory() {
        
        let alertController = UIAlertController(title: "Please enter a valid category name", message: "", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        alertController.preferredAction = okAction
        
        present(alertController, animated: true, completion: nil)
    }
    
}
