//
//  custom_cell_person.swift
//  layout_1
//
//  Created by Rijul Gupta on 7/20/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit



class custom_cell_person: UITableViewCell{
    
    @IBOutlet var name_label: UILabel!
    @IBOutlet var friends_label: UILabel!
    
    @IBOutlet var hashtagHolder:UIView!
    
    @IBOutlet var interactionButton:UIButton!
    
    @IBOutlet var userImage:UIImageView!
    
    var is_friend = "no"
    var comment_id = "nil"
    
    var hashtags = [NSString]()
    var hashtagButtons = [UIButton?]()
    var widthFiller = 0
    var yPos = 10.0
    var hasLoadedInfo = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.layer.borderWidth=0.0
        userImage.layer.masksToBounds = false
        // postLabelHolder.layer.borderColor = color.CGColor//UIColor.blackColor().CGColor
        // userImage.frame = CGRectMake(20, 20, 40, 40)
        userImage.layer.cornerRadius = userImage.layer.frame.width/2
        userImage.clipsToBounds = true
        
        name_label.font = UIFont(name: "HelveticaNeue-Light", size: 18.0)
        friends_label.font = UIFont(name: "HelveticaNeue-Thin", size: 12.0)
        
        
        
        
        let color: UIColor = UIColor( red: CGFloat(51.0/255.0), green: CGFloat(51.0/255.0), blue: CGFloat(51.0/255.0), alpha: CGFloat(0.2) )
        
        let color2: UIColor = UIColor( red: CGFloat(200.0/255.0), green: CGFloat(200.0/255.0), blue: CGFloat(230.0/255.0), alpha: CGFloat(1.0) )
        
        

        
    }
    
        //
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        
        // Configure the view for the selected state
    }
    
}