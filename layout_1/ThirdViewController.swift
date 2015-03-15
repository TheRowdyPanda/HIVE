
//
//  ThirdViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/7/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit



class ThirdViewController: UIViewController {
    
    
   // @IBOutlet var commentLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var commentView: UITextView!
    @IBOutlet var replyHolderView: UIView!

    @IBOutlet weak var bottomLayoutConstraint: NSLayoutConstraint!
    var testString = "1"
    var comment = "empty"
    var author = "empty"
    
    
    //let transportItems = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]

    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.commentLabel.text = comment
        self.commentView.text = comment
        self.authorLabel.text = author
        //var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("reload_table"), userInfo: nil, repeats: false)
        
        
        //self.tableView.registerClass(custom_cell.self, forCellReuseIdentifier: "custom_cell")
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //START AJAX
   
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    @IBAction func did_press_back(){
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func keyboardWillShowNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }
    
    func keyboardWillHideNotification(notification: NSNotification) {
        updateBottomLayoutConstraintWithNotification(notification)
    }
    
   

    
    func updateBottomLayoutConstraintWithNotification(notification: NSNotification) {
        
        println("S:LKDFJL:SKDFLSDK")
        let userInfo = notification.userInfo!
        
        let animationDuration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        let keyboardEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let convertedKeyboardEndFrame = view.convertRect(keyboardEndFrame, fromView: view.window)
        let rawAnimationCurve = (notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as NSNumber).unsignedIntValue << 16
        
        
        // let animationCurve = UIViewAnimationOptions.fromRaw(UInt(rawAnimationCurve))!
        
        let animationCurve = UIViewAnimationOptions(UInt(rawAnimationCurve))

        bottomLayoutConstraint.constant = 0 - CGRectGetMinY(convertedKeyboardEndFrame)/2 - replyHolderView.frame.height
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: .BeginFromCurrentState | animationCurve, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
    }
}
