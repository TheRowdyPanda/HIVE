//
//  ViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/14/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//


import UIKit
import CoreLocation


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, CLLocationManagerDelegate{
    
    let locationManager = CLLocationManager()
    
    var imageCache = [String : UIImage]()
    var refreshControl:UIRefreshControl!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var customSC: UISegmentedControl!
    
    var navCont: UINavigationController!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    var isBounce:Bool! = false
    
    @IBOutlet var radButton15ft: UIButton!
    @IBOutlet var radButton150ft: UIButton!
    @IBOutlet var radButton15min: UIButton!
    
    var hasLoaded = false
    var theJSON: NSDictionary!
    var savedFBID = "none"
    var numOfCells = 0
    var oldScrollPost:CGFloat = 0.0
    var radValue = 1
    
    
    var currentUserLocation = "none"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationManager.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        
        //get the user facebook id. This is used to identify the user in all ajax requests
        let defaults = NSUserDefaults.standardUserDefaults()
        savedFBID = defaults.stringForKey("saved_fb_id")!
        
        
        
        customSC.selectedSegmentIndex = 1
        let font = UIFont(name: "Arial", size: 22)
        let attr = NSDictionary(objects: [font!, UIColor.whiteColor()], forKeys: [NSFontAttributeName, NSForegroundColorAttributeName])
        //let attr = NSDictionary(object: font!, forKey: NSFontAttributeName)
       // customSC.titleForSegmentAtIndex(0) = "skdfK"
       // customSC.setTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.blueColor()]
       customSC.setTitleTextAttributes(attr, forState: UIControlState.Normal)
        customSC.setTitleTextAttributes(attr, forState: UIControlState.Highlighted)
        //customSC.titleTextAttributesForState(UIControlState.Normal) = attr
        
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "didPullRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
        
        //get the top comments in the "THEJSON" var, then reload the table
        //loadTopComments()
        
     //   showLoadingScreen()
        
        //set up the segmented control action
        customSC.addTarget(self, action: "toggleComments:", forControlEvents: .ValueChanged)
        
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.9 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            dispatch_async(dispatch_get_main_queue(),{
               // self.tableView.reloadData()
                //self.removeLoadingScreen()
                self.click15min()
            })
            
        }
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        
        let color: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(217.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0) )
        self.tableView.separatorColor = color
        //self.tableView.separatorStyle
        self.tableView.separatorInset.left = 0
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    //pragma mark - table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //make sure the json has loaded before we do anything
        if(hasLoaded == false){
            return numOfCells
        }
        else{
            return numOfCells
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let testImage = theJSON["results"]![indexPath.row]["image"] as String!
        
        if(testImage == "none"){
            var cell = tableView.dequeueReusableCellWithIdentifier("custom_cell_no_images") as custom_cell_no_images
            
            cell.separatorInset.left = -10
            cell.layoutMargins = UIEdgeInsetsZero
            
            
            cell.tag = 100
            
            //set the cell contents with the ajax data
            cell.comment_label?.text = theJSON["results"]![indexPath.row]["comments"] as String!
            cell.comment_id = theJSON["results"]![indexPath.row]["c_id"] as String!
            cell.author_label?.text = theJSON["results"]![indexPath.row]["author"] as String!
            cell.loc_label?.text = theJSON["results"]![indexPath.row]["location"] as String!
            cell.heart_label?.text = theJSON["results"]![indexPath.row]["hearts"] as String!
            cell.user_id = theJSON["results"]![indexPath.row]["user_id"] as String!
            
            
            let authorTap = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
            // 4
            authorTap.delegate = self
            cell.author_label?.tag = indexPath.row
            cell.author_label?.userInteractionEnabled = true
            cell.author_label?.addGestureRecognizer(authorTap)
            
            
            //find out if the user has liked the comment or not
            var hasLiked = theJSON["results"]![indexPath.row]["has_liked"] as String!
            
            if(hasLiked == "yes"){
                cell.heart_icon?.userInteractionEnabled = true
                cell.heart_icon?.image = UIImage(named: "honey_full.jpg")
                
                let voteDown = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
                // 4
                voteDown.delegate = self
                cell.heart_icon?.tag = indexPath.row
                cell.heart_icon?.addGestureRecognizer(voteDown)
                
                
            }
            else if(hasLiked == "no"){
                cell.heart_icon?.userInteractionEnabled = true
                cell.heart_icon?.image = UIImage(named: "honey_empty.jpg")
                
                let voteUp = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
                // 4
                voteUp.delegate = self
                cell.heart_icon?.tag = indexPath.row
                cell.heart_icon?.addGestureRecognizer(voteUp)
            }
            
            
         
            
            
            
            return cell

            
            
        }
        else{
        //image
        var cell = tableView.dequeueReusableCellWithIdentifier("custom_cell") as custom_cell
        
            cell.separatorInset.left = -10
            cell.layoutMargins = UIEdgeInsetsZero
        cell.imageLink = testImage
          cell.tag = 200
            

            
        //set the cell contents with the ajax data
        cell.comment_label?.text = theJSON["results"]![indexPath.row]["comments"] as String!
        cell.comment_id = theJSON["results"]![indexPath.row]["c_id"] as String!
        cell.author_label?.text = theJSON["results"]![indexPath.row]["author"] as String!
        cell.loc_label?.text = theJSON["results"]![indexPath.row]["location"] as String!
        cell.heart_label?.text = theJSON["results"]![indexPath.row]["hearts"] as String!
            
            let userFBID = theJSON["results"]![indexPath.row]["user_id"] as String!
        cell.user_id = userFBID
            
            let imageLink = "http://graph.facebook.com/\(userFBID)/picture?type=small"
            let url = NSURL(string: imageLink)
            let data2 = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            //            comImage.image = UIImage(data: data!)
            
            cell.userImage.image = UIImage(data:data2!)
        
        let authorTap = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
        // 4
        authorTap.delegate = self
        cell.author_label?.tag = indexPath.row
        cell.author_label?.userInteractionEnabled = true
        cell.author_label?.addGestureRecognizer(authorTap)
        
            
            let shareTap = UITapGestureRecognizer(target: self, action:Selector("shareComment:"))
            // 4
            shareTap.delegate = self
            cell.shareButton?.tag = indexPath.row
            cell.shareButton?.userInteractionEnabled = true
            cell.shareButton?.addGestureRecognizer(shareTap)
            
        
        //find out if the user has liked the comment or not
        var hasLiked = theJSON["results"]![indexPath.row]["has_liked"] as String!
        
        if(hasLiked == "yes"){
            cell.heart_icon?.userInteractionEnabled = true
            cell.heart_icon?.image = UIImage(named: "honey_full.jpg")
            
            let voteDown = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
            // 4
            voteDown.delegate = self
            cell.heart_icon?.tag = indexPath.row
            cell.heart_icon?.addGestureRecognizer(voteDown)
            
            
        }
        else if(hasLiked == "no"){
            cell.heart_icon?.userInteractionEnabled = true
            cell.heart_icon?.image = UIImage(named: "honey_empty.jpg")
            
            let voteUp = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
            // 4
            voteUp.delegate = self
            cell.heart_icon?.tag = indexPath.row
            cell.heart_icon?.addGestureRecognizer(voteUp)
        }
            
            
            //give a loading gif to UI
            var urlgif = NSBundle.mainBundle().URLForResource("loader", withExtension: "gif")
            var imageDatagif = NSData(contentsOfURL: urlgif!)
            
            
            let imagegif = UIImage.animatedImageWithData(imageDatagif!)
            
            cell.comImage.image = imagegif
            
            
            var image = self.imageCache[testImage]
            
            
            if( image == nil ) {
                // If the image does not exist, we need to download it
                var imgURL: NSURL = NSURL(string: testImage)!
                
                // Download an NSData representation of the image at the URL
                let request: NSURLRequest = NSURLRequest(URL: imgURL)
                NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                    if error == nil {
                        image = UIImage(data: data)
                        
                        // Store the image in to our cache
                        self.imageCache[testImage] = image
                        dispatch_async(dispatch_get_main_queue(), {
                            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? custom_cell {
                                cellToUpdate.comImage.image = image
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
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? custom_cell {
                        cellToUpdate.comImage?.image = image
                    }
                })
            }
     
            
            
            
        
        return cell
        }
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let comView = mainStoryboard.instantiateViewControllerWithIdentifier("com_focus_scene_id") as ThirdViewController
        
        let indCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(indCell?.tag == 100){
            let gotCell = tableView.cellForRowAtIndexPath(indexPath) as custom_cell_no_images
            
            comView.comment = gotCell.comment_label.text!
            
            comView.author = gotCell.author_label.text!
            comView.imgLink = "none2"
            comView.commentID = gotCell.comment_id
            
        }
        if(indCell?.tag == 200){
        let gotCell = tableView.cellForRowAtIndexPath(indexPath) as custom_cell

        comView.comment = gotCell.comment_label.text!
        
        comView.author = gotCell.author_label.text!
        comView.imgLink = gotCell.imageLink
        comView.commentID = gotCell.comment_id
        
        }
        // self.dismissViewControllerAnimated(true, completion: nil)
        
        self.presentViewController(comView, animated: true, completion: nil)
        
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        isBounce = true
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var currentOffset = scrollView.contentOffset.y;
        
        var test = self.oldScrollPost - currentOffset
        
        println("SCROLL:\(currentOffset)")
        println("SIZE:\(scrollView.contentSize.height)")
        println("FRAME:\(scrollView.frame.height)")
        if(test >= 0 ){
            //  animateBarDown()
        }
        else{
            //    animateBarUp()
            
        }
        
        
        self.oldScrollPost = currentOffset
        
        if(currentOffset > 20 && currentOffset < (scrollView.contentSize.height - scrollView.frame.height - 100)){
            animateBar(test)
        }
        
    }
    
    func animateBar(byNum: CGFloat){
        
        let initVal:CGFloat = -20
        let maxVal = 0 - self.navBar.frame.height - self.radButton150ft.frame.height*1.8
        
        
        topLayoutConstraint.constant = topLayoutConstraint.constant + byNum
        
        if(topLayoutConstraint.constant < maxVal){
            topLayoutConstraint.constant = maxVal
        }
        else if(topLayoutConstraint.constant > initVal){
            topLayoutConstraint.constant = initVal
        }
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .BeginFromCurrentState, animations: {
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }

    
    
    
    //pragma mark - ajax
    func loadTopComments(){
        
        showLoadingScreen()
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get2_top_comments")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["fbid":savedFBID, "recentLocation":currentUserLocation, "radiusValue":String(radValue)] as Dictionary<String, String>
        
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
    
    func loadNewComments(){
        
        
        showLoadingScreen()
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get2_new_comments")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["fbid":savedFBID, "recentLocation":currentUserLocation, "radiusValue":String(radValue)] as Dictionary<String, String>
        
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
    
    
    
    
    func reload_table(){
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.3 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            dispatch_async(dispatch_get_main_queue(),{
                self.tableView.reloadData()
                self.removeLoadingScreen()
            })
            
        }
        
    }
    
    
    
    func showUserProfile(sender: UIGestureRecognizer){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let profView = mainStoryboard.instantiateViewControllerWithIdentifier("profile_scene_id") as ProfileViewController
        
        
        var authorLabel = sender.view? as UILabel
        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as custom_cell_no_images
            
            //profView.comment = gotCell.comment_label.text!
            profView.userFBID = gotCell.user_id
            
            profView.userName = gotCell.author_label.text!
        }
        if(indCell?.tag == 200){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as custom_cell
            
            //profView.comment = gotCell.comment_label.text!
            profView.userFBID = gotCell.user_id
            
            profView.userName = gotCell.author_label.text!
        }
        
        
        self.presentViewController(profView, animated: true, completion: nil)
        
        
    }
    
    func shareComment(sender: UIGestureRecognizer){

        var sharedButton = sender.view? as UIImageView
        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag, inSection: 0))

        if(indCell?.tag == 100){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag, inSection: 0)) as custom_cell_no_images
            
            let shareCom = gotCell.comment_label.text
            
            let objectsToShare = [shareCom]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            self.presentViewController(activityVC, animated: true, completion: nil)
            
            
            
        }
        if(indCell?.tag == 200){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag, inSection: 0)) as custom_cell

        }
        
        
        

        
        
    }
    
    
    func toggleCommentVote(sender:UIGestureRecognizer){
        //get the attached sender imageview
        var heartImage = sender.view? as UIImageView
        //get the main view
        
        var indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: heartImage.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            
            var cellView = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: heartImage.tag, inSection: 0)) as custom_cell_no_images
            
            var cID = cellView.comment_id
            
            
            
            
            
            let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_toggle_comment_vote")
            //START AJAX
            var request = NSMutableURLRequest(URL: url!)
            var session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            var params = ["fbid":savedFBID, "comment_id":String(cID)] as Dictionary<String, String>
            
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
                        dispatch_async(dispatch_get_main_queue(),{
                            //change the heart image
                            
                            
                            
                            var testVote = parseJSON["results"]![0]["vote"] as String!
                            
                            if(testVote == "no"){
                            heartImage.image = UIImage(named: "honey_empty.jpg")
                            
                            //get heart label content as int
                            var curHVal = cellView.heart_label?.text?.toInt()
                            //get the heart label
                            cellView.heart_label?.text = String(curHVal! - 1)
                            }
                            else if(testVote == "yes"){
                                heartImage.image = UIImage(named: "honey_full.jpg")
                                
                                //get heart label content as int
                                var curHVal = cellView.heart_label?.text?.toInt()
                                //get the heart label
                                cellView.heart_label?.text = String(curHVal! + 1)
                            }
                        })
                        
                    }
                    else {
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        
                    }
                }
            })
            task.resume()

            
            
        }
        
        if(indCell?.tag == 200){
            
            var cellView = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: heartImage.tag, inSection: 0)) as custom_cell
            
            var cID = cellView.comment_id
            
            
            
            
            
            let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_toggle_comment_vote")
            //START AJAX
            var request = NSMutableURLRequest(URL: url!)
            var session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            var params = ["fbid":savedFBID, "comment_id":String(cID)] as Dictionary<String, String>
            
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
                        dispatch_async(dispatch_get_main_queue(),{
                            //change the heart image
                            
                            
                            
                            var testVote = parseJSON["results"]![0]["vote"] as String!
                            
                            if(testVote == "no"){
                                heartImage.image = UIImage(named: "honey_empty.jpg")
                                
                                //get heart label content as int
                                var curHVal = cellView.heart_label?.text?.toInt()
                                //get the heart label
                                cellView.heart_label?.text = String(curHVal! - 1)
                            }
                            else if(testVote == "yes"){
                                heartImage.image = UIImage(named: "honey_full.jpg")
                                
                                //get heart label content as int
                                var curHVal = cellView.heart_label?.text?.toInt()
                                //get the heart label
                                cellView.heart_label?.text = String(curHVal! + 1)
                            }
                        })
                        
                    }
                    else {
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        
                    }
                }
            })
            task.resume()
            
            
            
        }
        
    }
  
    
    
    
    
    
    // pragma mark - layout
    
    func showLoadingScreen(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let squareSize = screenSize.width * 0.5
        let xPos = screenSize.width/2 - squareSize/2
        let yPos = screenSize.height/2 - squareSize/2
        
        let holdView = UIView(frame: CGRect(x: xPos, y: yPos, width: squareSize, height: squareSize*1.1))
        holdView.backgroundColor = UIColor.whiteColor()
        holdView.tag = 999
        
        holdView.layer.borderWidth=1.0
        holdView.layer.masksToBounds = false
        holdView.layer.borderColor = UIColor.blackColor().CGColor
        //profilePic.layer.cornerRadius = 13
        holdView.layer.cornerRadius = holdView.frame.size.height/10
        holdView.clipsToBounds = true
        
        view.addSubview(holdView)
        
        
        
        
        
        
        var label = UILabel(frame: CGRectMake(0, 0, holdView.frame.width, holdView.frame.height*0.2))
        label.textAlignment = NSTextAlignment.Center
        label.text = "Loading Comments..."
        holdView.addSubview(label)
        
        
        
        
        // Returns an animated UIImage
        var url = NSBundle.mainBundle().URLForResource("loader", withExtension: "gif")
        var imageData = NSData(contentsOfURL: url!)
        
        
        let image = UIImage.animatedImageWithData(imageData!)//UIImage(named: imageName)
        let imageView = UIImageView(image: image!)
        
        let smallerSquareSize = squareSize*0.6
        let gPos = (holdView.frame.width - smallerSquareSize)/2
        
        
        imageView.frame = CGRect(x: gPos, y: gPos*1.8, width: smallerSquareSize, height: smallerSquareSize)
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
    
    @IBAction func showWriteViewController(){
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let writeView = mainStoryboard.instantiateViewControllerWithIdentifier("write_comment_scene_id") as WriteCommentViewController
        
        writeView.sentLocation = currentUserLocation
        
        
        // self.dismissViewControllerAnimated(true, completion: nil)
        
        self.presentViewController(writeView, animated: true, completion: nil)
        
    }
    
    
    func toggleComments(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadTopComments()
        case 1:
            loadNewComments()
        default:
            loadTopComments()
        }
    }
    
    
    
    
    
    
    //pragma mark - core location
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            
            if (error != nil) {
                println("Error:" + error.localizedDescription)
                return
                
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                //self.displayLocationInfo(pm)
                
                self.currentUserLocation = String("\(pm.location.coordinate.latitude), \(pm.location.coordinate.longitude)")
                //print(pm.location.coordinate.latitude)
                //print(pm.location.coordinate.longitude)
                
                println(self.currentUserLocation)
                
            }else {
                println("Error with data")
                
            }
            
            
        })
    }
    
    
    
    //pragma mark - location specificying buttons
    
    @IBAction func click15ft(){
        radValue = 1
        toggleLocButtonLayout()
        
    }
    @IBAction func click150ft(){
        radValue = 2
        toggleLocButtonLayout()
    }
    @IBAction func click15min(){
        radValue = 3
        toggleLocButtonLayout()
    }
    
    func toggleLocButtonLayout(){
        
        radButton15ft.backgroundColor = UIColor.clearColor()
        radButton150ft.backgroundColor = UIColor.clearColor()
        radButton15min.backgroundColor = UIColor.clearColor()
        radButton15ft.titleLabel?.textColor = UIColor.blackColor()
        radButton150ft.titleLabel?.textColor = UIColor.blackColor()
        radButton15min.titleLabel?.textColor = UIColor.blackColor()
        
        if(radValue == 1){
            radButton15ft.titleLabel?.textColor = UIColor.whiteColor()
            radButton15ft.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
        }
        if(radValue == 2){
             radButton150ft.titleLabel?.textColor = UIColor.whiteColor()
            radButton150ft.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        if(radValue == 3){
             radButton15min.titleLabel?.textColor = UIColor.whiteColor()
            radButton15min.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        }
        
        
        if(customSC.selectedSegmentIndex == 0){
            loadTopComments()
        }
        else if(customSC.selectedSegmentIndex == 1){
            loadNewComments()
        }
    }
    

    func didPullRefresh(sender:AnyObject)
    {
        if(customSC.selectedSegmentIndex == 0){
            loadTopComments()
        }
        else if(customSC.selectedSegmentIndex == 1){
            loadNewComments()
        }
        
        self.refreshControl.endRefreshing()
    }
    
}