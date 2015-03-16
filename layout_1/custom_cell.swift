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
    @IBOutlet var comImage:UIImageView!
    
    
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    var comment_id = "nil"
    var user_id = "nil"
    
   
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

//        
//        for c in comImage.constraints(){
//        comImage.removeConstraint(c as NSLayoutConstraint)
//        }
//        
    comImage.removeFromSuperview()
//        
        
//        let leftConstraint = NSLayoutConstraint(item:self.author_label,
//            attribute:NSLayoutAttribute.Top,
//            relatedBy:NSLayoutRelation.Equal,
//            toItem:self.comment_label,
//            attribute:NSLayoutAttribute.Bottom,
//            multiplier:1.0,
//            constant:20);
//        
//        self.addConstraint(leftConstraint);
//        
//        let leftConstraint2 = NSLayoutConstraint(item:self.loc_label,
//            attribute:NSLayoutAttribute.Top,
//            relatedBy:NSLayoutRelation.Equal,
//            toItem:self.comment_label,
//            attribute:NSLayoutAttribute.Bottom,
//            multiplier:1.0,
//            constant:20);
//        
//        self.addConstraint(leftConstraint2);
        
//        let leftConstraint = NSLayoutConstraint(item:self.author_label,
//            attribute:NSLayoutAttribute.Top,
//            relatedBy:NSLayoutRelation.Equal,
//            toItem:self.comment_label,
//            attribute:NSLayoutAttribute.Bottom,
//            multiplier:1.0,
//            constant:20);
//        
    //    self.addConstraint(leftConstraint);
        
        self.comment_label.numberOfLines = 0
        self.comment_label.sizeToFit()
        
        //topLayoutConstraint.secondItem = self.comment_label
//        let imageName = "honey_full.jpg"
//        let image = UIImage(named: imageName)
//        let imageView = UIImageView(image: image!)
//        
//        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 400)
//        imageView.backgroundColor = UIColor.blackColor()
//        self.addSubview(imageView)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
