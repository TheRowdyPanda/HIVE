//
//  FirstSceneViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/13/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit



class FirstSceneViewController: UIViewController{
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

   
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
       
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id")
        if(fbid != nil){
            
            if(fbid == "none"){
                let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
                let mainView = mainStoryboard.instantiateViewControllerWithIdentifier("fb_login_scene_id") as! UIViewController
                
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
                self.presentViewController(mainView, animated: false, completion: nil)
            }
            else{
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
            let fbView = mainStoryboard.instantiateViewControllerWithIdentifier("main_tab_bar_scene_id") as! UITabBarController
            
               //let fbView = mainStoryboard.instantiateViewControllerWithIdentifier("pick_hashtags_id") as! pickHashtagsInitialViewController
            //let fbView = mainStoryboard.instantiateViewControllerWithIdentifier("PersonTableViewControllerID") as! PersonTableViewController
                
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            self.presentViewController(fbView, animated: false, completion: nil)
            }
            
            
        }
        else{
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
            let mainView = mainStoryboard.instantiateViewControllerWithIdentifier("fb_login_scene_id") as! UIViewController
            
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            self.presentViewController(mainView, animated: false, completion: nil)
            
            
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    func testUserLogin(){
        
        
    }
    
}