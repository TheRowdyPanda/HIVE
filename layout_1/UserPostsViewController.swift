//
//  UserPostsViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/15/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

import UIKit



class UserPostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, CLLocationManagerDelegate{
    
  //  let locationManager = CLLocationManager()
    
     @IBOutlet var tableView:UITableView!
    
    var userFBID = "none"
    
    var hasLoaded = false
    var theJSON: NSDictionary!
    var imageCache = [String : UIImage]()
    var numOfCells = 0
    
    var voterCache = [Int : String]()
    var voterValueCache = [Int : String]()

   // var currentUserLocation = "none"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        
//        
//        self.locationManager.delegate = self
//        
//        //  self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
//        
//        self.locationManager.requestWhenInUseAuthorization()
//        self.locationManager.requestAlwaysAuthorization()
//        
//        self.locationManager.startUpdatingLocation()
//        
        loadUserComments()
        
        var tracker = GAI.sharedInstance().trackerWithTrackingId("UA-58702464-2")
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("User Posts", action: "Show", label: "", value: nil).build() as [NSObject : AnyObject])
        
    }
    
    override func viewDidAppear(animated: Bool) {
      
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
        if(hasLoaded == false){
            return numOfCells
        }
        else{
            //return 5
            return numOfCells
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let testImage = theJSON["results"]![indexPath.row]["image"] as! String!
        //var cell:AnyObject
        
        if(testImage == "none"){
            var cell = tableView.dequeueReusableCellWithIdentifier("custom_cell_no_images", forIndexPath: indexPath) as! custom_cell_no_images
//            cell.tag = 100
//            
//            cell.comment_label?.text = theJSON["results"]![indexPath.row]["comments"] as! String!
//            //cell.comment_label?.text = "\U0001f31d"
//            cell.comment_id = theJSON["results"]![indexPath.row]["c_id"] as! String!
//            cell.author_label?.text = theJSON["results"]![indexPath.row]["author"] as! String!
//            cell.loc_label?.text = theJSON["results"]![indexPath.row]["location"] as! String!
//            cell.heart_label?.text = voterValueCache[indexPath.row] as String!
//            cell.user_id = theJSON["results"]![indexPath.row]["user_id"] as! String!
//            
//            
//            
//            
//            let authorTap = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
//            // 4
//            authorTap.delegate = self
//            cell.author_label?.tag = indexPath.row
//            cell.author_label?.userInteractionEnabled = true
//            cell.author_label?.addGestureRecognizer(authorTap)
//            
//            
//            //find out if the user has liked the comment or not
//            var hasLiked = voterCache[indexPath.row] as String!
//            
//            if(hasLiked == "yes"){
//                cell.heart_icon?.userInteractionEnabled = true
//                cell.heart_icon?.image = UIImage(named: "honey_full.jpg")
//                
//                let voteDown = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
//                // 4
//                voteDown.delegate = self
//                cell.heart_icon?.tag = indexPath.row
//                cell.heart_icon?.addGestureRecognizer(voteDown)
//                
//                
//            }
//            else if(hasLiked == "no"){
//                cell.heart_icon?.userInteractionEnabled = true
//                cell.heart_icon?.image = UIImage(named: "honey_empty.jpg")
//                
//                let voteUp = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
//                // 4
//                voteUp.delegate = self
//                cell.heart_icon?.tag = indexPath.row
//                cell.heart_icon?.addGestureRecognizer(voteUp)
//            }
//            
//            
            return cell
        }
        else{
            var cell = tableView.dequeueReusableCellWithIdentifier("custom_cell", forIndexPath: indexPath) as! custom_cell
            
            cell.tag = 200
            
            cell.comment_label?.text = theJSON["results"]![indexPath.row]["comments"] as! String!
            //cell.comment_label?.text = "\U0001f31d"
            cell.comment_id = theJSON["results"]![indexPath.row]["c_id"] as! String!
            cell.author_label?.text = theJSON["results"]![indexPath.row]["author"] as! String!
            cell.loc_label?.text = theJSON["results"]![indexPath.row]["location"] as! String!
            cell.heart_label?.text = voterValueCache[indexPath.row] as String!
            cell.user_id = theJSON["results"]![indexPath.row]["user_id"] as! String!
            cell.imageLink = testImage
            if(testImage == "none"){
                
            }
            else{
                var image = self.imageCache[testImage]
                if( image == nil ) {
                    //give a loading gif to UI
                    var urlgif = NSBundle.mainBundle().URLForResource("loader", withExtension: "gif")
                    var imageDatagif = NSData(contentsOfURL: urlgif!)
                    
                    
                    let imagegif = UIImage.animatedImageWithData(imageDatagif!)
                    
                    cell.comImage.image = imagegif
                    
                    // If the image does not exist, we testImage to download it
                    var imgURL:NSURL = NSURL(string: testImage)!
                    
                    // Download an NSData representation of the image at the URL
                    let request: NSURLRequest = NSURLRequest(URL: imgURL)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                        if error == nil {
                            image = UIImage(data: data)
                            
                            // Store the image in to our cache
                            self.imageCache[testImage
                                ] = image
                            dispatch_async(dispatch_get_main_queue(), {
                                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? custom_cell{
                                    cellToUpdate.comImage?.image = image
                                    
                                    //  cellToUpdate.comImage.addConstraints(oldAssConstraints)
                                    //    let frame = cell.comImage.frame
                                    //   cellToUpdate.comImage.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.width*(4/3)   )
                                    
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
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? custom_cell{
                            cellToUpdate.comImage?.image = image
                            
                            //   cellToUpdate.comImage.addConstraints(oldAssConstraints)
                            //  let frame = cell.comImage.frame
                            //  cellToUpdate.comImage.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: frame.width*(4/3)   )
                            
                        }
                    })
                }
                
            }
            
            
            
            let authorTap = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
            // 4
            authorTap.delegate = self
            cell.author_label?.tag = indexPath.row
            cell.author_label?.userInteractionEnabled = true
            cell.author_label?.addGestureRecognizer(authorTap)
            
            
            //find out if the user has liked the comment or not
            var hasLiked = voterCache[indexPath.row] as String!
            
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

    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
//        
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
//        let comView = mainStoryboard.instantiateViewControllerWithIdentifier("com_focus_scene_id") as ThirdViewController
//        
//        let gotCell = tableView.cellForRowAtIndexPath(indexPath)
//        
//        if(gotCell?.tag == 100){
//            let gotCell2 = tableView.cellForRowAtIndexPath(indexPath) as custom_cell_no_images
//            comView.comment = gotCell2.comment_label.text!
//            comView.author = gotCell2.author_label.text!
//        }
//        else if(gotCell?.tag == 200){
//            let gotCell2 = tableView.cellForRowAtIndexPath(indexPath) as custom_cell
//            comView.comment = gotCell2.comment_label.text!
//            comView.author = gotCell2.author_label.text!
//            
//        }
//        
//        
//        
//        
//        
//        
//        // self.dismissViewControllerAnimated(true, completion: nil)
//        
//        self.presentViewController(comView, animated: true, completion: nil)
        
        
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let comView = mainStoryboard.instantiateViewControllerWithIdentifier("com_focus_scene_id") as! ThirdViewController
        
        let gotCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(gotCell?.tag == 100){
            let gotCell2 = tableView.cellForRowAtIndexPath(indexPath) as! custom_cell_no_images
            comView.comment = gotCell2.comment_label.text!
            comView.author = gotCell2.author_label.text!
            comView.imgLink = "none2"
            comView.commentID = gotCell2.comment_id
            comView.authorFBID = gotCell2.user_id
        }
        else if(gotCell?.tag == 200){
            let gotCell2 = tableView.cellForRowAtIndexPath(indexPath) as! custom_cell
            comView.comment = gotCell2.comment_label.text!
            comView.author = gotCell2.author_label.text!
            comView.imgLink = gotCell2.imageLink
            comView.commentID = gotCell2.comment_id
            comView.authorFBID = gotCell2.user_id
            
        }
        
        let mainView = mainStoryboard.instantiateViewControllerWithIdentifier("main_view_scene_id") as! ViewController
        //comView.sentLocation = self.currentUserLocation
        
        comView.sentLocation = mainView.currentUserLocation
         self.presentViewController(comView, animated: true, completion: nil)
    }

    
    
    
    //pragma mark - ajax
    func loadUserComments(){
        
        
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_user_comments")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["fb_id":userFBID] as Dictionary<String, String>
        
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
            
            
            
            //self.theJSON = NSJSONSerialization.JSONObjectWithData(json, options:.MutableLeaves, error: &err) as? NSDictionary
            
            
            // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
            if(err != nil) {
                println(err!.localizedDescription)
                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("Error could not parse JSON: '\(jsonStr)'")
                
               // self.showErrorScreen("top")
                
            }
            else {
                // The JSONObjectWithData constructor didn't return an error. But, we should still
                
                
                
                // check and make sure that json has a value using optional binding.
                if let parseJSON = json {
                    
                    self.theJSON = json
                    self.writeVoterCache()
                    self.hasLoaded = true
                    self.numOfCells = parseJSON["results"]!.count
                    
                    self.reload_table()
                    
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                   // self.showErrorScreen("top")
                }
            }
        })
        task.resume()
        //END AJAX
        
        
        
    }
    
    func writeVoterCache(){
        
        let finNum = (theJSON["results"]!.count - 1)
        
        if(finNum >= 0){
            
            for index in 0...finNum{
                self.voterCache[index] = theJSON["results"]![index]["has_liked"] as? String
                self.voterValueCache[index] = theJSON["results"]![index]["hearts"] as? String
            }
        }
        
    }
    
    
    func toggleCommentVote(sender:UIGestureRecognizer){
        //get the attached sender imageview
        
        var heartImage:AnyObject
        
        heartImage = sender.view!
        
        //var heartImage = sender.view? as UIImageView
        //get the main view
        
        var indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: heartImage.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            
            var cellView = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: heartImage.tag, inSection: 0)) as! custom_cell_no_images
            
            var cID = cellView.comment_id
            
            
            
            
            
            let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_toggle_comment_vote")
            //START AJAX
            var request = NSMutableURLRequest(URL: url!)
            var session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            var params = ["fbid":userFBID, "comment_id":String(cID)] as Dictionary<String, String>
            
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
                            
                            
                            
                            var testVote = parseJSON["results"]![0]["vote"] as! String!
                            
                            if(testVote == "no"){
                                cellView.heart_icon?.image = UIImage(named: "heart_empty.png")
                                
                                //get heart label content as int
                                var curHVal = cellView.heart_label?.text?.toInt()
                                //get the heart label
                                self.voterValueCache[heartImage.tag] = String(curHVal! - 1)
                                cellView.heart_label?.text = String(curHVal! - 1)
                                //self.theJSON["results"]![100]["has_liked"] = "no" as AnyObject!?
                                self.voterCache[heartImage.tag] = "no"
                            }
                            else if(testVote == "yes"){
                                cellView.heart_icon.image = UIImage(named: "heart_full.png")
                                
                                //get heart label content as int
                                var curHVal = cellView.heart_label?.text?.toInt()
                                //get the heart label
                                self.voterValueCache[heartImage.tag] = String(curHVal! + 1)
                                cellView.heart_label?.text = String(curHVal! + 1)
                                self.voterCache[heartImage.tag] = "yes"
                                // self.theJSON["results"]![heartImage.tag]["has_liked"] = "yes" as [AnyObject]
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
            
            var cellView = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: heartImage.tag, inSection: 0)) as! custom_cell
            
            var cID = cellView.comment_id
            
            
            
            
            
            let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_toggle_comment_vote")
            //START AJAX
            var request = NSMutableURLRequest(URL: url!)
            var session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            var params = ["fbid":userFBID, "comment_id":String(cID)] as Dictionary<String, String>
            
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
                            
                            
                            
                            var testVote = parseJSON["results"]![0]["vote"] as! String!
                            
                            if(testVote == "no"){
                                cellView.heart_icon?.image = UIImage(named: "heart_empty.png")
                                
                                //get heart label content as int
                                var curHVal = cellView.heart_label?.text?.toInt()
                                //get the heart label
                                self.voterValueCache[heartImage.tag] = String(curHVal! - 1)
                                cellView.heart_label?.text = String(curHVal! - 1)
                                //save the new vote value in our array
                                self.voterCache[heartImage.tag] = "no"
                            }
                            else if(testVote == "yes"){
                                cellView.heart_icon?.image = UIImage(named: "heart_full.png")
                                
                                //get heart label content as int
                                var curHVal = cellView.heart_label?.text?.toInt()
                                //get the heart label
                                self.voterValueCache[heartImage.tag] = String(curHVal! + 1)
                                cellView.heart_label?.text = String(curHVal! + 1)
                                self.voterCache[heartImage.tag] = "yes"
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


    func showUserProfile(sender: UIGestureRecognizer){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let profView = mainStoryboard.instantiateViewControllerWithIdentifier("profile_scene_id") as! ProfileViewController
        
        
        var authorLabel = sender.view as! UILabel
        
        let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        
        
        // let gotCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(gotCell?.tag == 100){
            let gotCell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell_no_images
            profView.userFBID = gotCell2.user_id
            profView.userName = gotCell2.author_label.text!
        }
        else if(gotCell?.tag == 200){
            let gotCell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell
            profView.userFBID = gotCell2.user_id
            profView.userName = gotCell2.author_label.text!
            
        }
        
        
        self.presentViewController(profView, animated: true, completion: nil)
        
        
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
    

    
    
    //pragma mark - core location
    
    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
//            
//            NSThread.sleepForTimeInterval(0.001)
//            if (error != nil) {
//                println("Error:" + error.localizedDescription)
//                return
//                
//            }
//            
//            if placemarks.count > 0 {
//                let pm = placemarks[0] as CLPlacemark
//                //self.displayLocationInfo(pm)
//                
//                self.currentUserLocation = String("\(pm.location.coordinate.latitude), \(pm.location.coordinate.longitude)")
//                //print(pm.location.coordinate.latitude)
//                //print(pm.location.coordinate.longitude)
//                
//                println(self.currentUserLocation)
//                
//            }else {
//                println("Error with data")
//                
//            }
//            
//            
//        })
//    }
//    
//    
//    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        
//        self.locationManager.startUpdatingLocation()
//        
//    }
//    

    
    

    
}