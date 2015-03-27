//
//  custom_cell.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/6/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit



class custom_cell: UITableViewCell{
    
    @IBOutlet var heart_label: UILabel!
    @IBOutlet var comment_label: UILabel!
    @IBOutlet var author_label: UILabel!
    @IBOutlet var heart_icon: UIImageView!
    @IBOutlet var loc_label: UILabel!
    @IBOutlet var comImage:UIImageView!
    
    
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    var comment_id = "nil"
    var user_id = "nil"
    var imageLink = "none"
    
   
    

    override func awakeFromNib() {
        super.awakeFromNib()

        
        // Initialization code
        

//        if(imageLink == "none"){
//            //xcomImage.removeFromSuperview()
//            //            /http://i.imgur.com/qG8Pg55.jpg
//            let url = NSURL(string: "http://i.imgur.com/ckSBw57.jpg")
//            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
//            comImage.image = UIImage(data: data!)
//        }
//        else{
//            
//            let url = NSURL(string: imageLink)
//            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
//            comImage.image = UIImage(data: data!)
//            
//            
//        }

        self.comment_label.numberOfLines = 0
        self.comment_label.sizeToFit()
        

        
    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.comImage = nil
//        
//    }
    
//    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: false)

        // Configure the view for the selected state
    }

}
