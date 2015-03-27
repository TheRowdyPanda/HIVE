//
//  reply_cell.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/24/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//
//
//  user_cell.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/15/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit



class reply_cell: UITableViewCell {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var replyLabel: UILabel!
    //@IBOutlet var followButton: UIButton!
    //@IBOutlet var valueLabel: UILabel!
    
    var userFBID = "none"
    
    
    
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
        

        self.replyLabel.numberOfLines = 0
        self.replyLabel.sizeToFit()
        //replyLabel.frame = CGRectMake(replyLabel.frame.origin.x, replyLabel.frame.origin.y, 100, replyLabel.frame.height)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //
}
