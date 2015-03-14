//
//  MyProfileViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/12/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//


import UIKit


//http://graph.facebook.com/xUID/picture?width=720&height=720
class MyProfileViewController: UIViewController {
    
    

    @IBOutlet var profilePic: UIImageView!
    
    @IBOutlet var loadingScreen: UIImageView!
    
    //let transportItems = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //titleItem.title = "TESTING"
        
        var url = NSBundle.mainBundle().URLForResource("loader", withExtension: "gif")
        var imageData = NSData(contentsOfURL: url!)
        
        // Returns an animated UIImage
        
        loadingScreen.image =
            UIImage.animatedImageWithData(imageData!)
        
     
        //var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("reload_table"), userInfo: nil, repeats: false)
        
        
        //self.tableView.registerClass(custom_cell.self, forCellReuseIdentifier: "custom_cell")
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //START AJAX
        
       
        
        
        
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        getUserPicture()
         removeLoadingScreen()
    }
    
    func getUserPicture(){
    
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        let url = NSURL(string: "http://graph.facebook.com/\(fbid)/picture?width=720&height=720")
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        profilePic.image = UIImage(data: data!)
        profilePic.layer.borderWidth=1.0
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.whiteColor().CGColor
        //profilePic.layer.cornerRadius = 13
        profilePic.layer.cornerRadius = profilePic.frame.size.height/2
        profilePic.clipsToBounds = true
        
    }
    
    func removeLoadingScreen(){
        
        UIView.animateWithDuration(0.3, animations: {
            //            self.myFirstLabel.alpha = 1.0
            //            self.myFirstButton.alpha = 1.0
            //            self.mySecondButton.alpha = 1.0
            self.loadingScreen.alpha = 0.0
        })
        
    }
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(true)
//        
//        println("SLKDJF:LSKDJF:LKDJSF:KLSDFLKJ")
//        
//    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func did_press_back(){
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}