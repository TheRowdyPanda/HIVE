//
//  user_cell.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/15/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit



class user_cell: UITableViewCell {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var followButton: UIButton!
    //@IBOutlet var valueLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //userImage.image = UIImage(data: data!)
        //userImage.layer.borderWidth=1.0
        userImage.layer.masksToBounds = false
        //userImage.layer.borderColor = UIColor.whiteColor().CGColor
        //profilePic.layer.cornerRadius = 13
        userImage.layer.cornerRadius = userImage.frame.size.height
        userImage.clipsToBounds = true
        
      
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
