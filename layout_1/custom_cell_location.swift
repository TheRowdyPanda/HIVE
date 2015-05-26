//
//  custom_cell_location.swift
//  layout_1
//
//  Created by Rijul Gupta on 5/23/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit



class custom_cell_location: UITableViewCell{
    

    
    @IBOutlet var locationLabel: UILabel!
    
    @IBOutlet var user1NameLabel: UILabel!
    @IBOutlet var user2NameLabel: UILabel!
    @IBOutlet var user3NameLabel: UILabel!
    @IBOutlet var user1Pic:UIImageView!
    @IBOutlet var user2Pic:UIImageView!
    @IBOutlet var user3Pic:UIImageView!
    
    
    @IBOutlet var locPic1:UIImageView!
    @IBOutlet var locPic2:UIImageView!
    @IBOutlet var locPic3:UIImageView!
    @IBOutlet var locPic4:UIImageView!
    
    
    @IBOutlet var numMoreLabel: UILabel!
    
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    var user1Id = "nil"
    var user2Id = "nil"
    var user3Id = "nil"
    var image1Link = "none"
    var image2Link = "none"
    var image3Link = "none"
    var image4Link = "none"
    var latLon = "none"
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
        
        
    
        
        
        user1Pic.layer.borderWidth=0.0
        user1Pic.layer.masksToBounds = false
        user1Pic.layer.cornerRadius = user1Pic.layer.frame.width/2
        user1Pic.clipsToBounds = true
        
        user2Pic.layer.borderWidth=0.0
        user2Pic.layer.masksToBounds = false
        user2Pic.layer.cornerRadius = user2Pic.layer.frame.width/2
        user2Pic.clipsToBounds = true
        
        user3Pic.layer.borderWidth=0.0
        user3Pic.layer.masksToBounds = false
        user3Pic.layer.cornerRadius = user3Pic.layer.frame.width/2
        user3Pic.clipsToBounds = true
        
        
        
        
        
        
        let color: UIColor = UIColor( red: CGFloat(51.0/255.0), green: CGFloat(51.0/255.0), blue: CGFloat(51.0/255.0), alpha: CGFloat(0.2) )

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)
        
        // Configure the view for the selected state
    }
    
}