//
//  UserFriendsViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/15/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//


import UIKit



class UserFriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userFBID = "none"
    var ajaxRequestString = "none"
    
   @IBOutlet var tableView:UITableView!
    @IBOutlet var titleItem:UINavigationItem!
    
    var theJSON: NSDictionary!
    var hasLoaded:Bool = false
    var numOfCells = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = tableView.frame.height/8
        
        if(ajaxRequestString == "followers"){
            //titleItem.title = "Followers"
            get_user_followers()
        }
        else if(ajaxRequestString == "following"){
            //titleItem.title = "Following"
            get_user_following()
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        println(ajaxRequestString)
        println(userFBID)
        
    
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func did_press_back(){
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    
    //pragma mark - table view
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //make sure the json has loaded before we do anything
        return numOfCells
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("user_cell") as user_cell
        
    
        var fbid = theJSON["results"]![indexPath.row]["userID"] as String!

        
        let url = NSURL(string: "http://graph.facebook.com/\(fbid)/picture?width=50&height=50")
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        
        
        cell.userImage?.image = UIImage(data: data!)
        cell.nameLabel.text = theJSON["results"]![indexPath.row]["userName"] as String!

        
        let followTest = theJSON["results"]![indexPath.row]["userFollow"] as String!
        //test if general user is following the presented user
        //cell.followButton.titleLabel?.text = "test"
        
        if(followTest == "yes"){//the user is follow, we give option to change
             //cell.followButton.setTitle("Unfollow", forState: UIControlState.Normal)
            cell.followButton.setImage(UIImage(named: "Unfollow.png"), forState: UIControlState.Normal)
        }
        else{
           // cell.followButton.setTitle("Follow", forState: UIControlState.Normal)
            cell.followButton.setImage(UIImage(named: "Follow.png"), forState: UIControlState.Normal)
        }

        
       // cell.followButton.addTarget(self, action: "DidPressFollow:", forControlEvents: .TouchUpInside)
        //cell.followButton.tag = indexPath.row
        cell.userFBID = fbid

        return cell
    }
    
//    
//    func DidPressFollow(sender: UIButton!){
//        println("KLSDFJKSDFJ:\(sender.tag)")
//        
//
//        //self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: sender.tag, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
//    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let profView = mainStoryboard.instantiateViewControllerWithIdentifier("profile_scene_id") as ProfileViewController
        
        
      //  var authorLabel = sender.view? as UILabel
        
     //   let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        
        
         let gotCell = tableView.cellForRowAtIndexPath(indexPath) as user_cell

            profView.userFBID = gotCell.userFBID
            profView.userName = gotCell.nameLabel.text!

        
        
        self.presentViewController(profView, animated: true, completion: nil)
        
        
        
    }
    
    
    
    //pragma mark - ajax
    func get_user_followers(){
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_user_followers")
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
                    
                    
                    self.theJSON = json
                    self.hasLoaded = true
                    self.numOfCells = parseJSON["results"]!.count
                    
                    self.reload_table()
                    
                    
                    
                }
                else {
                    
                    
                }
            }
        })
        task.resume()
        //END AJAX

        
    }
    
    func get_user_following(){
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let fbid = defaults.stringForKey("saved_fb_id") as String!
        
        
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_user_following")
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
                    
                    
                    self.theJSON = json
                    self.hasLoaded = true
                    self.numOfCells = parseJSON["results"]!.count
                    
                    self.reload_table()
                    
                    
                    
                }
                else {
                    
                    
                }
            }
        })
        task.resume()
        //END AJAX
        
        
    }
    
    
    func reload_table(){
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.3 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            dispatch_async(dispatch_get_main_queue(),{
                self.tableView.reloadData()
                //self.removeLoadingScreen()
            })
            
        }
        
    }

    
    
    
    
    
    
    
    
       
    
}
