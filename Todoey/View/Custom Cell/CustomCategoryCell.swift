//
//  CustomCategoryCell.swift
//  Todoey
//
//  Created by Sandip Mahajan on 09/01/19.
//  Copyright © 2019 RAMAppBrewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class CustomCategoryCell: SwipeTableViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var numberOfItems: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
