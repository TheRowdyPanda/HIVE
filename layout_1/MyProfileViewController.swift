//
//  MyProfileViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/12/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//


import UIKit


//http://graph.facebook.com/xUID/picture?width=720&height=720
class MyProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FBLoginViewDelegate {
    
    
    @IBOutlet var fbLoginView : FBLoginView!
    @IBOutlet var profilePic: UIImageView!
    
    //@IBOutlet var loadingScreen: UIImageView!
    
    @IBOutlet var tableView:UITableView!
    @IBOutlet var navBar:UINavigationBar!
    @IBOutlet var navTitle:UINavigationItem!
    //let transportItems = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
    
    let leftHandItems = ["","Last Check In", "Posts", "Followers", "Following"]
    
    let rightHandItems = ["","@This Place", "250", "92", "99"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //titleItem.title = "TESTING"
        
        var url = NSBundle.mainBundle().URLForResource("loader", withExtension: "gif")
        var imageData = NSData(contentsOfURL: url!)
        
        // Returns an animated UIImage
        
       //self.navBar.topItem.title = "SDKFJ"

     navTitle.title = "My Profile"
        //var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("reload_table"), userInfo: nil, repeats: false)
        
        
        
       tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.tableView.rowHeight = tableView.frame.height/5
        
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        getUserPicture()
        // removeLoadingScreen()
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
    
//    func removeLoadingScreen(){
//        
//        UIView.animateWithDuration(0.3, animations: {
//            //            self.myFirstLabel.alpha = 1.0
//            //            self.myFirstButton.alpha = 1.0
//            //            self.mySecondButton.alpha = 1.0
//            self.loadingScreen.alpha = 0.0
//        })
//        
//    }
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
    
    @IBAction func did_press_karma(){
        
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let karmaView = mainStoryboard.instantiateViewControllerWithIdentifier("karma_scene_id") as KarmaViewController
        

        self.presentViewController(karmaView, animated: true, completion: nil)
        
    }
    
    func did_press_logout(){
        
        FBSession.activeSession().closeAndClearTokenInformation()
        let defaults = NSUserDefaults.standardUserDefaults()
        //let fbid = defaults.stringForKey("saved_fb_id") as String!
        defaults.removeObjectForKey("saved_fb_id")
        
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let mainView = mainStoryboard.instantiateViewControllerWithIdentifier("fb_login_scene_id") as UIViewController
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.presentViewController(mainView, animated: false, completion: nil)
        
    }
    
    
    
    //pragma mark - table view

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //make sure the json has loaded before we do anything
       return 5
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("profile_cell") as profile_cell
        
        
        cell.idLabel?.text = self.leftHandItems[indexPath.row]
      
        
        cell.valueLabel?.text = self.leftHandItems[indexPath.row]

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
            
            
                    // self.dismissViewControllerAnimated(true, completion: nil)

                    self.presentViewController(postView, animated: true, completion: nil)
            
            
        }
        //followers
        if(indexPath.row == 3){
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let friendView = mainStoryboard.instantiateViewControllerWithIdentifier("user_friends_scene_id") as UserFriendsViewController
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let fbid = defaults.stringForKey("saved_fb_id") as String!
            
            
            friendView.ajaxRequestString = "followers"
            friendView.userFBID = fbid
            // self.dismissViewControllerAnimated(true, completion: nil)
            
            self.presentViewController(friendView, animated: true, completion: nil)
        }
        //following
        if(indexPath.row == 4){
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let friendView = mainStoryboard.instantiateViewControllerWithIdentifier("user_friends_scene_id") as UserFriendsViewController
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let fbid = defaults.stringForKey("saved_fb_id") as String!
            
            
            friendView.ajaxRequestString = "following"
            friendView.userFBID = fbid
            // self.dismissViewControllerAnimated(true, completion: nil)
            
            self.presentViewController(friendView, animated: true, completion: nil)
            
        }
    }
    
    
    
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {

    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){

        // getMyFriends()
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        did_press_logout()
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
    }
    
    
    

    
    
}