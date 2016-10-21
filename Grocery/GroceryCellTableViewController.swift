//
//  GroceryCellTableViewController.swift
//  Grocery
//
//  Created by Kegham Karsian on 10/19/16.
//  Copyright © 2016 appologi. All rights reserved.
//

import UIKit

class GroceryCellTableViewController: UITableViewCell {
    
    
    @IBOutlet var groceryTitle: UILabel!

    @IBOutlet var timeAdded: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
