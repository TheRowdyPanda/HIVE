//
//  custom_cell.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/6/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit



class custom_cell: UITableViewCell {
    
    @IBOutlet var heart_label: UILabel!
    @IBOutlet var comment_label: UILabel!
    @IBOutlet var author_label: UILabel!
    @IBOutlet var heart_icon: UIImageView!
    @IBOutlet var loc_label: UILabel!
    
    var comment_id = "nil"
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.comment_label.numberOfLines = 0
        self.comment_label.sizeToFit()
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
