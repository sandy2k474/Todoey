//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Sandip Mahajan on 01/01/19.
//  Copyright © 2019 RAMAppBrewery. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
   var categoryArray = [Category]()
   var selectedCategory = Category()
   let viewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].title!
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoryArray[indexPath.row]
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
            
            let category = Category(context: self.viewContext)
            category.title = textField?.text!
            
            self.categoryArray.append(category)
            
            self.saveCategory()
            
            self.tableView.reloadData()
        }
        
        alertController.addAction(action)
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Category"
            textField = alertTextField
        }
        
      
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func saveCategory() {
        
        do {
        try viewContext.save()
        }
        catch {
            print("Error saving context \(error)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do {
        categoryArray = try viewContext.fetch(request)
        tableView.reloadData()
        }
        catch {
            print("Error fetching Category Data \(error)")
        }
    }
    
}
