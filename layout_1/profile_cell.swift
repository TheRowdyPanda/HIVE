//
//  profile_cell.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/14/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//
import UIKit



class profile_cell: UITableViewCell {
    
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
