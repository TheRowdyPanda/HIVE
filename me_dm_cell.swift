//
//  me_dm_cell.swift
//  layout_1
//
//  Created by Rijul Gupta on 8/27/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

class me_dm_cell: UITableViewCell {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    //@IBOutlet var followButton: UIButton!
    //@IBOutlet var valueLabel: UILabel!
    
    var userFBID = "none"
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        
        messageLabel.numberOfLines = 0
        messageLabel.sizeToFit()
        
        messageLabel.drawTextInRect(CGRect(x: messageLabel.frame.origin.x, y: messageLabel.frame.origin.y, width: messageLabel.frame.width + 5.0, height: messageLabel.frame.height + 5.0))
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
}
