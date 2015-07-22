//
//  FBLoginViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/11/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit

let fbIDConstant = "saved_fb_id"


class FBLoginViewController: UIViewController, FBLoginViewDelegate, UIGestureRecognizerDelegate {
    
@IBOutlet var fbLoginView : FBLoginView!
    @IBOutlet var tcLabel: UILabel!
    
    var ffList = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        //main_view_scene_id
        
        let underlineAttribute = [NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Terms and Conditions", attributes: underlineAttribute)
        tcLabel.attributedText = underlineAttributedString
        
        
        
        
        let TCTap = UITapGestureRecognizer(target: self, action:Selector("didTapTandC:"))
        // 4
        TCTap.delegate = self
        tcLabel.userInteractionEnabled = true
        tcLabel.addGestureRecognizer(TCTap)
        
        
        
        
    }
    
    func didTapTandC(sender: UIGestureRecognizer){
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let tcView = mainStoryboard.instantiateViewControllerWithIdentifier("terms_and_cond_id") as! TermsAndConditionsViewController
        
        
       // self.dismissViewControllerAnimated(true, completion: nil)
        
        self.presentViewController(tcView, animated: false, completion: nil)
        
        
    }
    override func viewDidAppear(animated: Bool) {
        
        testUserLogin()
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id")
        if(fbid != nil){
            
            if(fbid == "none"){
                
            }
            else{
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
            let fbView = mainStoryboard.instantiateViewControllerWithIdentifier("main_tab_bar_scene_id") as! UITabBarController
            
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            self.presentViewController(fbView, animated: false, completion: nil)
            }
            
            
            
        }

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        println("User Logged In")
        println("This is where you perform a segue.")
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let fbView = mainStoryboard.instantiateViewControllerWithIdentifier("main_tab_bar_scene_id") as! UITabBarController
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.presentViewController(fbView, animated: false, completion: nil)
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
        println("User Name: \(user.name)")
        var userID = user.objectForKey("id") as! String
        println("user id: \(userID)")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(userID, forKey: "saved_fb_id")
       getMyFriends()
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }

    
    //parse user friends list into readable string
    func getMyFriends(){
        var friendsRequest : FBRequest = FBRequest.requestForMyFriends()
        var friendList = ""
        friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            var resultdict = result as! NSDictionary
            println("Result Dict: \(resultdict)")
            var data : NSArray = resultdict.objectForKey("data") as! NSArray
            
            for i in 0...data.count {
                let valueDict : NSDictionary = data[i] as! NSDictionary
                let id = valueDict.objectForKey("id") as! String
                println("the id value is \(id)")
                friendList = friendList + "\(id), "
                self.ffList = self.ffList + "\(id), "
                
                
                if i == data.count - 1{
                    self.sendFinalList()
                }
                
            }
            
          //  var friends = resultdict.objectForKey("data") as! NSArray
            //println("Found \(friends.count) friends")
            
            
        }
        
        println("FINAL FRIENDS LIST:\(friendList)")
    }
    
    //send the friend list to our servers
    //we use the friends list in determining which posts to show the user
    //we also use it to show mutual friends between users
    //the friends list is vital to our app and we need facebook login
    func sendFinalList(){
        println("FINAL FRIENDS FINAL LIST:\(ffList)")
        
                //START AJAX
                //let url = NSURL(string: "http://www.groopie.co/mobile_get2_top_comments")
                let url = NSURL(string: "http://groopie.pythonanywhere.com/recieve_fbfriends_list")
                var request = NSMutableURLRequest(URL: url!)
                var session = NSURLSession.sharedSession()
                request.HTTPMethod = "GET"
        
                var params = ["ffList":ffList] as Dictionary<String, String>
        
                var err: NSError?
                request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
        
                var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                    println("Response: \(response)")
                    var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                    println("Body: \(strData)")
                    var err: NSError?
                    var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
        
        
                    // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                    if(err != nil) {
                        println(err!.localizedDescription)
                        let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Error could not parse JSON: '\(jsonStr)'")
                    }
                    else {
        
                        if let parseJSON = json {
        
                        }
                        else {
        
                        }
                    }
                })
                task.resume()
                //END AJAX

        
        
    }
    
    func testUserLogin(){
        
        
//        //START AJAX
//        //let url = NSURL(string: "http://www.groopie.co/mobile_get2_top_comments")
//        let url = NSURL(string: "http://groopie.pythonanywhere.com/login")
//        var request = NSMutableURLRequest(URL: url!)
//        var session = NSURLSession.sharedSession()
//        request.HTTPMethod = "GET"
//        
//        var params = ["username":"jameson", "password":"password"] as Dictionary<String, String>
//        
//        var err: NSError?
//        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &err)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        
//        var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
//            println("Response: \(response)")
//            var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
//            println("Body: \(strData)")
//            var err: NSError?
//            var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
//            
//            
//            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
//            if(err != nil) {
//                println(err!.localizedDescription)
//                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
//                println("Error could not parse JSON: '\(jsonStr)'")
//            }
//            else {
//
//                if let parseJSON = json {
//
//                }
//                else {
//
//                }
//            }
//        })
//        task.resume()
//        //END AJAX

    }
    
}