//
//  NotificationsViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 4/7/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit

class Notifications: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    

    @IBOutlet var tableView: UITableView! //holds notifications

    
    var savedFBID = "none"
    
    //  var comImage: UIImageView!
    //    @IBOutlet var comImage: UIImageView!
    
    var sentLocation = "none"
    
    
    var hasLoaded = false
    var theJSON: NSDictionary!
    var focusTableOn = "none"
    var numOfCells = 0
    //let transportItems = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let defaults = NSUserDefaults.standardUserDefaults()
        savedFBID = defaults.stringForKey("saved_fb_id")!
      
        tableView.estimatedRowHeight = 168.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let color: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(217.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0) )
        self.tableView.separatorColor = color
        self.tableView.separatorInset.left = 0
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        
        
        
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
        super.viewWillAppear(animated)
        
        loadNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    
    @IBAction func did_press_back(){
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //pragma mark - table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if(hasLoaded == false){
            return numOfCells
        }
        else{
            return numOfCells
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        
        println("DID SHOW CELL")
        
        var cell = UITableViewCell()
        
        let otherUser = theJSON["results"]![indexPath.row]["u2Name"] as String!
        let time = theJSON["results"]![indexPath.row]["time"] as String!
        
        let type = theJSON["results"]![indexPath.row]["type"] as String!
        var action = ""
        
        
//        1 is liking a comment
//        2 is liking a reply
//        3 is replying to comment
//        4 is following user
        if(type == "1"){
            action = "liked your comment"
            cell.tag = (theJSON["results"]![indexPath.row]["c_id"] as String!).toInt()!
        }
        if(type == "2"){
            action = "liked your reply"
            cell.tag = (theJSON["results"]![indexPath.row]["c_id"] as String!).toInt()!
        }
        if(type == "3"){
            action = "replied to your comment"
            cell.tag = (theJSON["results"]![indexPath.row]["c_id"] as String!).toInt()!
        }
        if(type == "4"){
            action = "followed you"
            cell.tag = (theJSON["results"]![indexPath.row]["u2Id"] as String!).toInt()!
        }
        
        let retString = otherUser + " " + action + " " + time
        
        cell.textLabel?.text = retString
        return cell
        
        
    }
    
    
    
    
    
    
    
    
    func loadNotifications(){
        
        
        // showLoadingScreen()
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_user_notifications")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        // var params = ["fbid":savedFBID, "recentLocation":currentUserLocation, "radiusValue":String(radValue)] as Dictionary<String, String>
        
        var params = ["fbid":fbid, "gfbid":fbid] as Dictionary<String, String>
        
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
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                
                
                
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    
                                        self.theJSON = json
                                        self.hasLoaded = true
                                        self.numOfCells = parseJSON["results"]!.count
                    
                                        self.reload_table()
                    
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    
                }
            }
        })
        task.resume()
        //END AJAX
        
        
        
    }

    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let type = theJSON["results"]![indexPath.row]["type"] as String!
        
        //        1 is liking a comment
        //        2 is liking a reply
        //        3 is replying to comment
        //        4 is following user
        
        if(type == "1"){
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
            let likeView = mainStoryboard.instantiateViewControllerWithIdentifier("comment_likers_id") as CommentLikersViewController
            
            
            var myCustomViewController: ViewController = ViewController(nibName: nil, bundle: nil)
            
            let currentUserLocation = myCustomViewController.currentUserLocation
            
                likeView.sentLocation = currentUserLocation
                likeView.commentID = theJSON["results"]![indexPath.row]["c_id"] as String!
                

            
            
            self.presentViewController(likeView, animated: true, completion: nil)
            
        }
        if(type == "2"){
            
        }
        if(type == "3"){
            
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let repView = mainStoryboard.instantiateViewControllerWithIdentifier("comment_reply_id") as CommentReplyViewController
            
            var myCustomViewController: ViewController = ViewController(nibName: nil, bundle: nil)
            
            let currentUserLocation = myCustomViewController.currentUserLocation
            
                
                repView.sentLocation = currentUserLocation
                repView.commentID =  theJSON["results"]![indexPath.row]["c_id"] as String!
                //profView.comment = gotCell.comment_label.text!
                // profView.userFBID = gotCell.user_id
                
                //profView.userName = gotCell.author_label.text!
            self.presentViewController(repView, animated: true, completion: nil)
            
        }
        if(type == "4"){
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let profView = mainStoryboard.instantiateViewControllerWithIdentifier("profile_scene_id") as ProfileViewController
            
            let newUserName = theJSON["results"]![indexPath.row]["u2Name"] as String!
            let newUserId = theJSON["results"]![indexPath.row]["u2FBID"] as String!
            profView.userFBID = newUserId
            profView.userName = newUserName
            self.presentViewController(profView, animated: true, completion: nil)

            
            
        }
    }
    
       func reload_table(){
        
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.3 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            dispatch_async(dispatch_get_main_queue(),{
                self.tableView.reloadData()
                // self.removeLoadingScreen()
            })
            
        }
        
    }
}
