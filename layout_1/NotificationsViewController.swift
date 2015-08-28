//
//  NotificationsViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 4/7/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit

class Notifications: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate, UIGestureRecognizerDelegate {
    

    @IBOutlet var tableView: UITableView! //holds notifications

    
    var savedFBID = "none"
    
    //  var comImage: UIImageView!
    //    @IBOutlet var comImage: UIImageView!
    
    var sentLocation = "none"
     var userImageCache = [String: UIImage]()
    
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
        
        //var cell = UITableViewCell()
        
        var cell = tableView.dequeueReusableCellWithIdentifier("notification_cell") as! notification_cell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.separatorInset.left = -10
        cell.layoutMargins = UIEdgeInsetsZero
        
        
        let otherUser = theJSON["results"]![indexPath.row]["u2Name"] as! String!
        let time = theJSON["results"]![indexPath.row]["time"] as! String!
        
        let type = theJSON["results"]![indexPath.row]["type"] as! String!
        var action = ""
        var imTit = "blank.png"
        
//        1 is liking a comment
//        2 is liking a reply
//        3 is replying to comment
//        4 is following user
        if(type == "1"){
            action = "liked your comment"
            cell.tag = (theJSON["results"]![indexPath.row]["c_id"] as! String!).toInt()!
            imTit = "Like.png"
        }
        if(type == "2"){
            action = "liked your reply"
            cell.tag = (theJSON["results"]![indexPath.row]["c_id"] as! String!).toInt()!
            imTit = "Like.png"
        }
        if(type == "3"){
            action = "replied to your comment"
            cell.tag = (theJSON["results"]![indexPath.row]["c_id"] as! String!).toInt()!
            imTit = "Comment.png"
        }
        if(type == "4"){
            action = "followed you"
            cell.tag = (theJSON["results"]![indexPath.row]["u2Id"] as! String!).toInt()!
            imTit = "Follow.png"
        }
        if(type == "5"){
            action = " wants to connect"
            cell.tag = (theJSON["results"]![indexPath.row]["u2Id"] as! String!).toInt()!
            imTit = "Follow.png"
        }
        
        //let retString = otherUser + " " + action + " " + time
        let retString = action
       // cell.textLabel?.text = retString
       // cell.textLabel?.numberOfLines = 0
        cell.actionLabel.text = retString
        cell.actionLabel.numberOfLines = 0
        cell.user2NameLabel.text = otherUser
        cell.timeLabel.text = time
        
        cell.typeImage.image = UIImage(named: imTit)
        
        
        let authorTap = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
        // 4
        authorTap.delegate = self
        cell.user2NameLabel?.tag = indexPath.row
        cell.user2NameLabel?.userInteractionEnabled = true
        cell.user2NameLabel?.addGestureRecognizer(authorTap)
        
        let authorTap2 = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
        // 4
        authorTap2.delegate = self
        cell.user2Image?.tag = indexPath.row
        cell.user2Image?.userInteractionEnabled = true
        cell.user2Image?.addGestureRecognizer(authorTap2)
        
        
        
        var fbid = theJSON["results"]![indexPath.row]["u2FBID"] as! String!
        cell.user2FBID = fbid
        
        let testUserImg = "http://graph.facebook.com/\(fbid)/picture?width=30&height=30"
        
        //let url = NSURL(string: "http://graph.facebook.com/\(fbid)/picture?width=50&height=50")
        // let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        
        var upimage = self.userImageCache[testUserImg]
        if( upimage == nil ) {
            // If the image does not exist, we need to download it
            
            var imgURL: NSURL = NSURL(string: testUserImg)!
            
            // Download an NSData representation of the image at the URL
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    upimage = UIImage(data: data)
                    
                    // Store the image in to our cache
                    self.userImageCache[testUserImg] = upimage
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? notification_cell {
                            cellToUpdate.user2Image?.image = upimage
                        }
                    })
                }
                else {
                    println("Error: \(error.localizedDescription)")
                }
            })
            
        }
        else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? notification_cell {
                    cellToUpdate.user2Image?.image = upimage
                }
            })
        }
        

        
        
        
        return cell
        
        
    }
    
    
    
    
    
    
    func showUserProfile(sender: UIGestureRecognizer){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let profView = mainStoryboard.instantiateViewControllerWithIdentifier("profile_scene_id") as! ProfileViewController
        
        
        //var authorLabel = sender.view? as UILabel
        var authorLabel:AnyObject
        
        authorLabel = sender.view!
        
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! notification_cell
            
            //profView.comment = gotCell.comment_label.text!
            profView.userFBID = gotCell.user2FBID
            
            profView.userName = gotCell.user2NameLabel.text!

        
        self.presentViewController(profView, animated: true, completion: nil)
        
        
    }

    
    
    
    
    
    func loadNotifications(){
        
        
         showLoadingScreen()
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
            self.removeLoadingScreen()
            
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
        
        
        let type = theJSON["results"]![indexPath.row]["type"] as! String!
        
        //        1 is liking a comment
        //        2 is liking a reply
        //        3 is replying to comment
        //        4 is following user
        
        if(type == "1"){
            
//            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            let likeView = mainStoryboard.instantiateViewControllerWithIdentifier("comment_likers_id") as CommentLikersViewController
//            var myCustomViewController: ViewController = ViewController(nibName: nil, bundle: nil)
//            let currentUserLocation = myCustomViewController.currentUserLocation
//                likeView.sentLocation = currentUserLocation
//                likeView.commentID = theJSON["results"]![indexPath.row]["c_id"] as String!
//            self.presentViewController(likeView, animated: true, completion: nil)
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let comView = mainStoryboard.instantiateViewControllerWithIdentifier("com_focus_scene_id") as! ThirdViewController
            var myCustomViewController: ViewController = ViewController(nibName: nil, bundle: nil)
            
            let currentUserLocation = myCustomViewController.currentUserLocation
                comView.sentLocation = currentUserLocation
            comView.sentLocation = currentUserLocation
            comView.commentID = theJSON["results"]![indexPath.row]["c_id"] as! String!
            comView.focusTableOn = "likers"
           // comView.imgLink = "none2"
            self.presentViewController(comView, animated: true, completion: nil)
        
            
            
        }
        if(type == "2"){
            
        }
        if(type == "3"){
            
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let comView = mainStoryboard.instantiateViewControllerWithIdentifier("com_focus_scene_id") as! ThirdViewController
            var myCustomViewController: ViewController = ViewController(nibName: nil, bundle: nil)
            
            let currentUserLocation = myCustomViewController.currentUserLocation
            comView.sentLocation = currentUserLocation
            comView.sentLocation = currentUserLocation
            comView.commentID = theJSON["results"]![indexPath.row]["c_id"] as! String!
            comView.focusTableOn = "replies"
            // comView.imgLink = "none2"
            self.presentViewController(comView, animated: true, completion: nil)
            
            
        }
        if(type == "4"){
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let profView = mainStoryboard.instantiateViewControllerWithIdentifier("profile_scene_id") as! ProfileViewController
            
            let newUserName = theJSON["results"]![indexPath.row]["u2Name"] as! String!
            let newUserId = theJSON["results"]![indexPath.row]["u2FBID"] as! String!
            profView.userFBID = newUserId
            profView.userName = newUserName
            self.presentViewController(profView, animated: true, completion: nil)

            
            
        }
    }
    
    
    
    func showLoadingScreen(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let w = screenSize.width * 0.8
        let h = w * 0.283
        let squareSize = screenSize.width * 0.2
        let xPos = screenSize.width/2 - w/2
        let yPos = screenSize.height/2 - h/2
        
        let holdView = UIView(frame: CGRect(x: xPos, y: yPos, width: w, height: h))
        holdView.backgroundColor = UIColor.whiteColor()
        holdView.tag = 999
        
        holdView.layer.borderWidth=1.0
        holdView.layer.masksToBounds = false
        holdView.layer.borderColor = UIColor.clearColor().CGColor
        //profilePic.layer.cornerRadius = 13
        holdView.layer.cornerRadius = holdView.frame.size.height/10
        holdView.clipsToBounds = true
        
        view.addSubview(holdView)
        
        
        
        
        
        
        var label = UILabel(frame: CGRectMake(0, 0, holdView.frame.width, holdView.frame.height*0.2))
        label.textAlignment = NSTextAlignment.Center
        label.text = "Loading Comments..."
        //holdView.addSubview(label)
        
        
        
        
        // Returns an animated UIImage
        var url = NSBundle.mainBundle().URLForResource("loader", withExtension: "gif")
        var imageData = NSData(contentsOfURL: url!)
        
        
        let image = UIImage.animatedImageWithData(imageData!)//UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        let smallerSquareSize = squareSize*0.6
        let gPos = (holdView.frame.width*0.2)/2
        let kPos = (holdView.frame.height*0.2)/2
        
        
        imageView.frame = CGRect(x: gPos, y: kPos, width: w*0.8, height: h*0.8)
        holdView.addSubview(imageView)
        
    }
    
    
    func removeLoadingScreen(){
        //self.loadingScreen.alpha = 0.0
        
        for view in self.view.subviews {
            if(view.tag == 999){
                view.removeFromSuperview()
            }
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
