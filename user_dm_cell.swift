//
//  user_dm_cell.swift
//  layout_1
//
//  Created by Rijul Gupta on 8/23/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//


class user_dm_cell: UITableViewCell {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    //@IBOutlet var followButton: UIButton!
    //@IBOutlet var valueLabel: UILabel!
    
    var userFBID = "none"
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.clipsToBounds = true

        
         messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
