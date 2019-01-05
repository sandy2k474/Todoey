//
//  Category.swift
//  Todoey
//
//  Created by Sandip Mahajan on 03/01/19.
//  Copyright © 2019 RAMAppBrewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var title: String = ""
    let items = List<Item>()
    
}
