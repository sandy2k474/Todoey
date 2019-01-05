//
//  Item.swift
//  Todoey
//
//  Created by Sandip Mahajan on 03/01/19.
//  Copyright © 2019 RAMAppBrewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
