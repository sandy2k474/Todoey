//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Sandip Mahajan on 05/01/19.
//  Copyright © 2019 RAMAppBrewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    tableView.register(UINib(nibName: "CustomCategoryCell", bundle: nil), forCellReuseIdentifier: "Cell")
}
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCategoryCell
        
        cell.delegate = self
        
        return cell
    }

func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    guard orientation == .right else { return nil }
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
        
        self.updateModel(at: indexPath)

    }
    
    let moreActions = SwipeAction(style: .default, title: "More") { action, indexPath in
        
        self.moreActions(at: indexPath)
        
    }
    
    // customize the action appearance
    deleteAction.image = UIImage(named: "delete-icon")
    moreActions.image = UIImage(named: "more-icon")
    
    return [deleteAction, moreActions]
}

func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
    var options = SwipeOptions()
    options.expansionStyle = .destructive
    options.transitionStyle = .border
    return options
}
    
    func updateModel(at indexPath: IndexPath) {
        
    }
    
    func moreActions(at indexPath: IndexPath) {
        
    }


}
