//
//  TermsAndConditionsViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 6/27/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit


class TermsAndConditionsViewController: UIViewController, UIGestureRecognizerDelegate{

    @IBOutlet var eButton: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eButton.layer.masksToBounds = false
        eButton.layer.cornerRadius = eButton.frame.size.height/2
        eButton.clipsToBounds = true
        
   
        
        
        let TCTap = UITapGestureRecognizer(target: self, action:Selector("did_press_back:"))
        // 4
        TCTap.delegate = self
        eButton.userInteractionEnabled = true
        eButton.addGestureRecognizer(TCTap)
        
        
        
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    

    func did_press_back(sender: UIGestureRecognizer){
        
       self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
}