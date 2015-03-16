//
//  ProfileViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/7/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//


import UIKit


//http://graph.facebook.com/xUID/picture?width=720&height=720
class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    
    var commingFrom = "nil"
    
    var userName = "none"
    var userFBID = "none"
    
    
    
    @IBOutlet var profilePic: UIImageView!
    
    //@IBOutlet var loadingScreen: UIImageView!
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var navBar:UINavigationBar!
    @IBOutlet var navTitle:UINavigationItem!
    
    @IBOutlet var followButton:UIButton!
    //let transportItems = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    let leftHandItems = ["","Last Check In", "Posts", "Karma","Followers", "Following"]
    
    let rightHandItems = ["","@This Place", "250","1023", "92", "99"]
    
    //let transportItems = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
       // titleItem.title = "TESTING"

        
        
        
        var url = NSBundle.mainBundle().URLForResource("loader", withExtension: "gif")
        var imageData = NSData(contentsOfURL: url!)
        
        // Returns an animated UIImage
        
        //self.navBar.topItem.title = "SDKFJ"
        
        navTitle.title = userName
        //var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("reload_table"), userInfo: nil, repeats: false)
        
        
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.tableView.rowHeight = tableView.frame.height/5
        
        
        getUserPicture()
        
        followButton.titleLabel?.text = ""
        
        is_user_following()
        
    }
    
    func getUserPicture(){
        

        let fbid = userFBID
        
        let url = NSURL(string: "http://graph.facebook.com/\(fbid)/picture?width=300&height=300")
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        profilePic.image = UIImage(data: data!)
        profilePic.layer.borderWidth=1.0
        profilePic.layer.masksToBounds = false
        profilePic.layer.borderColor = UIColor.whiteColor().CGColor
        //profilePic.layer.cornerRadius = 13
        profilePic.layer.cornerRadius = profilePic.frame.size.width/8
        profilePic.clipsToBounds = true
        
    }
    
    func is_user_following(){
        
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_is_user_following")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["gUser_fbID":fbid, "iUser_fbID":userFBID] as Dictionary<String, String>
        
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
                    
                    
                    dispatch_async(dispatch_get_main_queue(),{
                   let isFollowing =  parseJSON["results"]![0]["value"] as String!
                    
                    if(isFollowing == "yes"){
                        
                        self.followButton.titleLabel?.text = "UnFollow"
                    }
                    else if(isFollowing == "no"){
                        
                        self.followButton.titleLabel?.text = "Follow"
                    }
                    })
                    
                    
                    
                }
                else {

                    
                }
            }
        })
        task.resume()
        //END AJAX
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func did_press_back(){
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func toggle_user_follow(){
    
        
        self.followButton.titleLabel?.text = "..."
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_toggle_user_follow")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["gUser_fbID":fbid, "iUser_fbID":userFBID] as Dictionary<String, String>
        
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
                    
                    
                    dispatch_async(dispatch_get_main_queue(),{
                         self.is_user_following()
                    })
                   
                    
                    
                    
                }
                else {
                    
                    
                }
            }
        })
        task.resume()
        //END AJAX
        
    }
    
    
    //pragma mark - table view
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //make sure the json has loaded before we do anything
        return 6
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("profile_cell") as profile_cell
        
        
        cell.idLabel?.text = self.leftHandItems[indexPath.row]
        
        
        cell.valueLabel?.text = self.leftHandItems[indexPath.row]
        
        if(indexPath.row == 0){
            cell.userInteractionEnabled = false
        }
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //nothing
        if(indexPath.row == 0){
            
        }
        //last check in
        if(indexPath.row == 1){
            
        }
        //posts
        if(indexPath.row == 2){
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let postView = mainStoryboard.instantiateViewControllerWithIdentifier("user_post_scene_id") as UserPostsViewController
            
            
            postView.userFBID = userFBID
            
            // self.dismissViewControllerAnimated(true, completion: nil)
            
            self.presentViewController(postView, animated: true, completion: nil)
            
            
        }
        //karma
        if(indexPath.row == 3){
            //is this clickable?
        }
        //followers
        if(indexPath.row == 4){
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let friendView = mainStoryboard.instantiateViewControllerWithIdentifier("user_friends_scene_id") as UserFriendsViewController

            
            
            friendView.ajaxRequestString = "followers"
            friendView.userFBID = userFBID
            // self.dismissViewControllerAnimated(true, completion: nil)
            
            self.presentViewController(friendView, animated: true, completion: nil)
        }
        //following
        if(indexPath.row == 5){
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let friendView = mainStoryboard.instantiateViewControllerWithIdentifier("user_friends_scene_id") as UserFriendsViewController
            

            
            friendView.ajaxRequestString = "following"
            friendView.userFBID = userFBID
            // self.dismissViewControllerAnimated(true, completion: nil)
            
            self.presentViewController(friendView, animated: true, completion: nil)
            
        }
    }
    
    
    
    

    
}