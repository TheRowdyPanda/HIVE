//
//  custom_cell_no_images.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/20/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//


import UIKit



class custom_cell_no_images: UITableViewCell {
    
    @IBOutlet var heart_label: UILabel!
    @IBOutlet var comment_label: UILabel!
    @IBOutlet var author_label: UILabel!
    @IBOutlet var heart_icon: UIImageView!
    @IBOutlet var loc_label: UILabel!
    
    
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    var comment_id = "nil"
    var user_id = "nil"
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.comment_label.numberOfLines = 0
        self.comment_label.sizeToFit()
        
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        
        // Configure the view for the selected state
    }
    
}