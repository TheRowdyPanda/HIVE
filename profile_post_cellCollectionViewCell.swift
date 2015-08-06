//
//  profile_post_cellCollectionViewCell.swift
//  layout_1
//
//  Created by Rijul Gupta on 7/25/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit

class profile_post_cellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var postTextLabel:UILabel!
    @IBOutlet var backgroundImage:UIImageView!
    @IBOutlet var heartIcon:UIImageView!
    @IBOutlet var heartLabel:UILabel!
    @IBOutlet var dateLabel:UILabel!
    @IBOutlet var timeLabel:UILabel!
    @IBOutlet var replyLabel:UILabel!
    @IBOutlet var textBacker:UIView!
    @IBOutlet var relationshipLabel:UILabel!
    @IBOutlet var hashtagHolder:UIView!
    
    var hashtags = [NSString]()
    var hashtagButtons = [UIButton?]()
    
    var widthFiller = 0
    var yPos = 10.0
    var hasLoadedInfo = false
    
    //@IBOutlet var hashtagHolderBottomConstraint:NSLayoutConstraint!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let color: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(241.0/255.0), blue: CGFloat(241.0/255.0), alpha: CGFloat(1.0) )
        self.contentView.backgroundColor = color
//
//        let cornerSpacer = CGFloat(5.0)
//      
//        backgroundImage = UIImageView(frame: self.contentView.frame)
//        backgroundImage.backgroundColor = color
//        contentView.addSubview(backgroundImage)
//        
//        textBacker = UIView(frame: CGRect(x: 10, y: 20, width: (self.contentView.frame.width - 20.0), height: (self.contentView.frame.size.height - 20.0)))
//        textBacker.backgroundColor = UIColor.whiteColor()
//        contentView.addSubview(textBacker);
//        
//        
//        //postTextLabel = UILabel(frame: CGRect(x: 10, y: 20, width: (self.contentView.frame.width - 20.0), height: (self.contentView.frame.size.height - 20.0)))
//        postTextLabel = UILabel()
//        //postTextLabel.frame = CGRect(x: 10, y: 20, width: (self.contentView.frame.width - 20.0), height: (self.contentView.frame.size.height - 20.0))
//        postTextLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
//        postTextLabel.textAlignment = .Center
//        postTextLabel.numberOfLines = -1
//        
//        
//        
//        let leftConstraint = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: postTextLabel, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 10)
//        let rightConstraint = NSLayoutConstraint(item: self.contentView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: postTextLabel, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 10)
//        let cenConstraint = NSLayoutConstraint(item: postTextLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
//        let heightConstraint = NSLayoutConstraint(item: postTextLabel, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 100)
//
//        
//        self.addConstraint(leftConstraint)
//        self.addConstraint(rightConstraint)
//        self.addConstraint(cenConstraint)
//        self.addConstraint(heightConstraint)
//       
//        contentView.addSubview(postTextLabel)
//        
//        
//        dateLabel = UILabel(frame: CGRect(x: 5, y: 5, width:100, height: 20))
//        dateLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
//        dateLabel.textAlignment = .Left
//        contentView.addSubview(dateLabel)
//        dateLabel.text = "oifjofjij";
//        
//        timeLabel = UILabel(frame: CGRect(x: self.contentView.frame.height - 100, y: 5, width:100, height: 20))
//        timeLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
//        timeLabel.textAlignment = .Right
//        contentView.addSubview(timeLabel)
//        timeLabel.text = "7:45";
//        
//        let heartSizer = CGFloat(10.0)
//        heartLabel = UILabel(frame: CGRect(x: self.contentView.frame.width - heartSizer - cornerSpacer, y: self.contentView.frame.height - heartSizer - cornerSpacer, width:heartSizer, height: heartSizer))
//        heartLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
//        heartLabel.textAlignment = .Left
//        contentView.addSubview(heartLabel)
//        heartLabel.text = "22";
//        
//        
//
//        heartIcon = UIImageView(frame: CGRect(x: (heartLabel.frame.origin.x - heartLabel.frame.width/2.0 - heartSizer), y: heartLabel.frame.origin.x, width:heartSizer, height: heartSizer))
//        heartIcon.backgroundColor = UIColor.redColor()
//        contentView.addSubview(heartIcon)
//        
        
        
        
    }

    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    
    

 
    


}
