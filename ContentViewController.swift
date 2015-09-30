//
//  ContentViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 9/21/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController{
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var descriptLabel:UILabel!
    var pageIndex: Int!
    var titleText: String!
    var imageFile: String!
    var descText: String!
    
    override func viewDidLoad() {
        self.imageView.image = UIImage(named: self.imageFile)
        self.titleLabel.text = self.titleText
        self.descriptLabel.text = self.descText
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = 2
        super.viewDidLoad()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}