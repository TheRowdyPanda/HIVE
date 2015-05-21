
//
//  notification_cell.swift
//  layout_1
//
//  Created by Rijul Gupta on 4/8/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit



class notification_cell: UITableViewCell {
    
    @IBOutlet var user2Image: UIImageView!
    @IBOutlet var user2NameLabel: UILabel!
    
    @IBOutlet var actionLabel: UILabel!
    @IBOutlet var typeImage:UIImageView!
    @IBOutlet var timeLabel:UILabel!
    //@IBOutlet var followButton: UIButton!
    //@IBOutlet var valueLabel: UILabel!
    
    var actionID = "none"
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //userImage.image = UIImage(data: data!)
        //userImage.layer.borderWidth=1.0
        user2Image.layer.masksToBounds = false
        //userImage.layer.borderColor = UIColor.whiteColor().CGColor
        //profilePic.layer.cornerRadius = 13
        user2Image.layer.cornerRadius = user2Image.frame.size.height/2
        user2Image.clipsToBounds = true
        
        
        self.actionLabel.numberOfLines = 0
        self.actionLabel.sizeToFit()
        //replyLabel.frame = CGRectMake(replyLabel.frame.origin.x, replyLabel.frame.origin.y, 100, replyLabel.frame.height)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //
}
