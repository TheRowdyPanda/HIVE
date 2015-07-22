//
//  ViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/14/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//

//The methods defined in this swift file and what they do
//loadTopComments
//loadNewComments
//reload_table
//showUserProfile
//showLikers

import UIKit
import CoreLocation
import Social



class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, CLLocationManagerDelegate, FBSDKAppInviteDialogDelegate{
    
    let locationManager = CLLocationManager()
    
    var imageCache = [String : UIImage]()
    var userImageCache = [String: UIImage]()
    var refreshControl:UIRefreshControl!
    
    @IBOutlet var tableView: UITableView!
    
    var navCont: UINavigationController!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    var isBounce:Bool! = false
    
    var voterCache = [Int : String]()
    var voterValueCache = [Int : String]()
    

    @IBOutlet var customSC: UISegmentedControl!
    
    var hasLoaded = false
    var theJSON: NSDictionary!
    var savedFBID = "none"
    var numOfCells = 0
    var oldScrollPost:CGFloat = 0.0
    var radValue = 1
    
    
    var currentUserLocation = "none"
    
  
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        println("Complete invite without error")
    }
    
    func appInviteDialog(appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: NSError!) {
        println("Error in invite \(error)")
    }

    
    func inviteFBFriends(){
        var inviteDialog:FBSDKAppInviteDialog = FBSDKAppInviteDialog()
        
        if(inviteDialog.canShow()){
            let appLinkUrl2:NSURL = NSURL(string: "http://google.com")!
            ///let previewImageUrl:NSURL = NSURL(string: "http://mylink.com/image.png")!
            
          //  var inviteContent:FBSDKAppInviteContent = FBSDKAppInviteContent(appLinkURL: appLinkUrl2)
            var inviteContent:FBSDKAppInviteContent = FBSDKAppInviteContent()
            inviteContent.appLinkURL = appLinkUrl2
           // inviteContent.appInvitePreviewImageURL = previewImageUrl
            
            inviteDialog.content = inviteContent
            inviteDialog.delegate = self
            inviteDialog.show()
        }
        
        
    }
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // inviteFBFriends()
        //UIApplication.sharedApplication().openURL(NSURL(string: "http://www.reddit.com")!)
        self.locationManager.delegate = self
        
        //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        //self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.startUpdatingLocation()
        //self.locationManager.distanceFilter = 3
        
        
        //get the user facebook id. This is used to identify the user in all ajax requests
        let defaults = NSUserDefaults.standardUserDefaults()
        savedFBID = defaults.stringForKey("saved_fb_id")!
        
        
        println("Saved ID:\(savedFBID)")
        
        let font = UIFont(name: "Raleway-Light", size: 14)
        let attr = NSDictionary(objects: [font!, UIColor.whiteColor()], forKeys: [NSFontAttributeName, NSForegroundColorAttributeName])
        let attr2 = NSDictionary(objects: [font!, UIColor.blackColor()], forKeys: [NSFontAttributeName, NSForegroundColorAttributeName])

        tableView.estimatedRowHeight = 300.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            println("------------------------------")
            println("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNamesForFamilyName(familyName as! String)
            println("Font Names = [\(names)]")
        }
        
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "didPullRefresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)

        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW,
            Int64(0.45 * Double(NSEC_PER_SEC)))
        
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            
            dispatch_async(dispatch_get_main_queue(),{
               // self.tableView.reloadData()
                //self.removeLoadingScreen()
                
                self.loadComments()
                
            })
            
        }
        
        
        var tracker = GAI.sharedInstance().trackerWithTrackingId("UA-58702464-2")
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Main View Scene", action: "View Did Load", label: savedFBID, value: nil).build() as [NSObject : AnyObject])
        
        
        
        
        //give device token to server for apns
        throwDeviceToken()
        
       // loadFakePlaces()
        
       // loadClusters()
        
        //show instructions screen for first time users
        
       // showInstructionsScreen()
        
        
        
        customSC.selectedSegmentIndex = 1
//        let font = UIFont(name: "Raleway-Bold", size: 16)
//        let attr = NSDictionary(objects: [font!, UIColor.whiteColor()], forKeys: [NSFontAttributeName, NSForegroundColorAttributeName])
//        let attr2 = NSDictionary(objects: [font!, UIColor.blackColor()], forKeys: [NSFontAttributeName, NSForegroundColorAttributeName])
        //let attr = NSDictionary(object: font!, forKey: NSFontAttributeName)
        // customSC.titleForSegmentAtIndex(0) = "skdfK"
        // customSC.setTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.blueColor()]
        customSC.setTitleTextAttributes(attr2 as [NSObject : AnyObject], forState: UIControlState.Normal)
        customSC.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: UIControlState.Highlighted)
        
        customSC.addTarget(self, action: "toggleComments:", forControlEvents: .ValueChanged)
        
        
    }
    
    
    
    func toggleComments(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            loadClusters()
        case 1:
            loadComments()
        default:
            loadClusters()
        }
    }
    
    func loadClusters(){
        
        
        var tracker = GAI.sharedInstance().trackerWithTrackingId("UA-58702464-2")
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Main View Scene", action: "Load Clusters", label: savedFBID, value: nil).build() as [NSObject : AnyObject])
        
        
        showLoadingScreen()
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_clusters")
        
        
     
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["fbid":savedFBID, "recentLocation":currentUserLocation] as Dictionary<String, String>
        
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
                
                //                dispatch_async(dispatch_get_main_queue(),{
                //
                //
                //                    if(self.currentUserLocation == "none"){
                //                        self.showErrorMessage("We're having trouble getting your location.", targetString: "loadNewComments")
                //                    }
                //                    else{
                //                        self.showErrorMessage("We're having trouble getting new comments.", targetString: "loadNewComments")
                //                    }
                //
                //                })
                
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
    
    func writeVoterCache(){
        
        let finNum = (theJSON["results"]!.count - 1)
        
        if(finNum >= 0){
        
            for index in 0...finNum{
                self.voterCache[index] = theJSON["results"]![index]["has_liked"] as? String
                self.voterValueCache[index] = theJSON["results"]![index]["hearts"] as? String
            }
        }
        
    }
    
    func loadComments(){
        
        var tracker = GAI.sharedInstance().trackerWithTrackingId("UA-58702464-2")
        tracker.send(GAIDictionaryBuilder.createEventWithCategory("Main View Scene", action: "Load Comments", label: savedFBID, value: nil).build() as [NSObject : AnyObject])
        
        loadNewComments()
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
       // self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLineEtched
        self.tableView.separatorInset.left = 0
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        //self.tableView.awakeFromNib()
    }
    
    //pragma mark - table view
    
//    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 500.0
//    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //make sure the json has loaded before we do anything
        if(hasLoaded == false){
            return numOfCells
        }
        else{
            if(numOfCells > 0){
                return numOfCells
            }
            else{
                return 1
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        if(numOfCells > 0){
        let testImage = theJSON["results"]![indexPath.row]["image"] as! String!
        
        let testType = theJSON["results"]![indexPath.row]["type"] as! String!
        //1 is comment with no image
        //2 is comment with image
        //3 islocation summary
        
        if(testType == "1"){
            var cell = tableView.dequeueReusableCellWithIdentifier("custom_cell_no_images") as! custom_cell_no_images
            
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.separatorInset.left = -10
            cell.layoutMargins = UIEdgeInsetsZero
            cell.imageLink = testImage
            cell.tag = 100
            
            
            
            //set the cell contents with the ajax data
            cell.comment_label?.text = theJSON["results"]![indexPath.row]["comments"] as! String!
            cell.comment_id = theJSON["results"]![indexPath.row]["c_id"] as! String!
            cell.author_label?.text = theJSON["results"]![indexPath.row]["author"] as! String!
            cell.loc_label?.text = theJSON["results"]![indexPath.row]["location"] as! String!
            cell.heart_label?.text = voterValueCache[indexPath.row] as String!
            cell.time_label?.text = theJSON["results"]![indexPath.row]["time"] as! String!
            cell.replyNumLabel?.text = theJSON["results"]![indexPath.row]["numComments"] as! String!
//            let myMutableString = NSMutableAttributedString(string: "Herro", attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
//            
//            let myMutableString2 = NSMutableAttributedString(string: "World", attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 8.0)!])
//            
//            myMutableString.appendAttributedString(myMutableString2)
//            
            
            //     cell.comment_label?.attributedText = myMutableString
            
            //var doit: NSAttributedString! = self.parseHTMLString(cell.comment_label?.text!)
            
            let asdfasd = cell.comment_label?.text!
            
            var gotURL = self.parseHTMLString(asdfasd!)
            
            println("OH YEAH:\(gotURL)")
            
            if(gotURL.count == 0){
                println("NO SHOW")
                cell.urlLink = "none"
            }
            else{
                println("LAST TIME BuDDY:\(gotURL.last)")
                cell.urlLink = gotURL.last! as! String
                
                let linkTap = UITapGestureRecognizer(target: self, action:Selector("clickComLink:"))
                // 4
                linkTap.delegate = self
                cell.comment_label?.tag = indexPath.row
                cell.comment_label?.userInteractionEnabled = true
                cell.comment_label?.addGestureRecognizer(linkTap)

            }
            
            
            
            let userFBID = theJSON["results"]![indexPath.row]["user_id"] as! String!
            cell.user_id = userFBID
            
           // cell.userImage.frame = CGRectMake(20, 20, 20, 20)
            let testUserImg = "http://graph.facebook.com/\(userFBID)/picture?type=small"
            
            //GET TEH USER IMAGE
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
                            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? custom_cell_no_images {
                                cellToUpdate.userImage?.image = upimage
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
                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? custom_cell_no_images {
                        cellToUpdate.userImage?.image = upimage
                    }
                })
            }
            
            
            
            
            
            
            
            
            let authorTap = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
            // 4
            authorTap.delegate = self
            cell.author_label?.tag = indexPath.row
            cell.author_label?.userInteractionEnabled = true
            cell.author_label?.addGestureRecognizer(authorTap)
            
            let authorTap2 = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
            // 4
            authorTap2.delegate = self
            cell.userImage?.tag = indexPath.row
            cell.userImage?.userInteractionEnabled = true
            cell.userImage?.addGestureRecognizer(authorTap2)
            
            
            
            let likersTap = UITapGestureRecognizer(target: self, action:Selector("showLikers:"))
            likersTap.delegate = self
            //            cell.likerButtonLabel?.tag = indexPath.row
            //            cell.likerButtonLabel?.userInteractionEnabled = true
            //            cell.likerButtonLabel?.addGestureRecognizer(likersTap)
            cell.heart_label?.tag = indexPath.row
            cell.heart_label?.userInteractionEnabled = true
            cell.heart_label?.addGestureRecognizer(likersTap)
            
            
            
            
            let repliesTap = UITapGestureRecognizer(target: self, action:Selector("showReplies:"))
            repliesTap.delegate = self
            cell.replyButtonImage?.tag = indexPath.row
            cell.replyButtonImage?.userInteractionEnabled = true
            cell.replyButtonImage?.addGestureRecognizer(repliesTap)
            
            let repliesTap2 = UITapGestureRecognizer(target: self, action:Selector("showReplies:"))
            repliesTap2.delegate = self
            cell.replyButtonLabel?.tag = indexPath.row
            cell.replyButtonLabel?.userInteractionEnabled = true
            cell.replyButtonLabel?.addGestureRecognizer(repliesTap2)
            
            let repliesTap3 = UITapGestureRecognizer(target: self, action:Selector("showReplies:"))
            repliesTap3.delegate = self
            cell.replyNumLabel?.tag = indexPath.row
            cell.replyNumLabel?.userInteractionEnabled = true
            cell.replyNumLabel?.addGestureRecognizer(repliesTap3)
            
            
            
            
            
            //
            
            //
            //
            let shareTap = UITapGestureRecognizer(target: self, action:Selector("shareComment:"))
            shareTap.delegate = self
            cell.shareLabel?.tag = indexPath.row
            cell.shareLabel?.userInteractionEnabled = true
            cell.shareLabel?.addGestureRecognizer(shareTap)
            // cell.bringSubviewToFront(cell.shareLabel)
            // cell.contentView.bringSubviewToFront(cell.shareLabel)
            
            let shareTap2 = UITapGestureRecognizer(target: self, action:Selector("shareComment:"))
            shareTap2.delegate = self
            cell.shareButton?.tag = indexPath.row
            cell.shareButton?.userInteractionEnabled = true
            cell.shareButton?.addGestureRecognizer(shareTap2)
            // cell.bringSubviewToFront(cell.shareButton)
            //
            
            //find out if the user has liked the comment or not
            var hasLiked = voterCache[indexPath.row] as String!
            
            if(hasLiked == "yes"){
                cell.heart_icon?.userInteractionEnabled = true
                cell.heart_icon?.image = UIImage(named: "heart_full.png")
                
                let voteDown = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
                // 4
                voteDown.delegate = self
                cell.heart_icon?.tag = indexPath.row
                cell.heart_icon?.addGestureRecognizer(voteDown)
                
                
            }
            else if(hasLiked == "no"){
                cell.heart_icon?.userInteractionEnabled = true
                cell.heart_icon?.image = UIImage(named: "heart_empty.png")
                
                let voteUp = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
                // 4
                voteUp.delegate = self
                cell.heart_icon?.tag = indexPath.row
                cell.heart_icon?.addGestureRecognizer(voteUp)
            }
            
    
        
            let voteUp2 = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
            cell.likerButtonHolder?.userInteractionEnabled = true
            voteUp2.delegate = self
            cell.likerButtonHolder?.tag = indexPath.row
            cell.likerButtonHolder?.addGestureRecognizer(voteUp2)

            
            
            
            
            return cell

            
            
        }
        else{
        //image
        var cell = tableView.dequeueReusableCellWithIdentifier("custom_cell") as! custom_cell
        
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.separatorInset.left = -10
            cell.layoutMargins = UIEdgeInsetsZero
        cell.imageLink = testImage
          cell.tag = 200
            

            
        //set the cell contents with the ajax data
        cell.comment_label?.text = theJSON["results"]![indexPath.row]["comments"] as! String!
        cell.comment_id = theJSON["results"]![indexPath.row]["c_id"] as! String!
        cell.author_label?.text = theJSON["results"]![indexPath.row]["author"] as! String!
        cell.loc_label?.text = theJSON["results"]![indexPath.row]["location"] as! String!
        cell.heart_label?.text = voterValueCache[indexPath.row] as String!
            cell.time_label?.text = theJSON["results"]![indexPath.row]["time"] as! String!
            cell.replyNumLabel?.text = theJSON["results"]![indexPath.row]["numComments"] as! String!
            let myMutableString = NSMutableAttributedString(string: "Herro", attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 18.0)!])
            
             let myMutableString2 = NSMutableAttributedString(string: "World", attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 8.0)!])
            
            myMutableString.appendAttributedString(myMutableString2)
            
            
       //     cell.comment_label?.attributedText = myMutableString
            
            //var doit: NSAttributedString! = self.parseHTMLString(cell.comment_label?.text!)
            
            let asdfasd = cell.comment_label?.text!
            
            var gotURL = self.parseHTMLString(asdfasd!)
            
            println("OH YEAH:\(gotURL)")
            
            if(gotURL.count == 0){
                println("NO SHOW")
                cell.urlLink = "none"
            }
            else{
                println("LAST TIME BuDDY:\(gotURL.last)")
                cell.urlLink = gotURL.last! as! String
                
                let linkTap = UITapGestureRecognizer(target: self, action:Selector("clickComLink:"))
                // 4
                linkTap.delegate = self
                cell.comment_label?.tag = indexPath.row
                cell.comment_label?.userInteractionEnabled = true
                cell.comment_label?.addGestureRecognizer(linkTap)
                
            }
            
            let userFBID = theJSON["results"]![indexPath.row]["user_id"] as! String!
        cell.user_id = userFBID
            let testUserImg = "http://graph.facebook.com/\(userFBID)/picture?type=small"
       //     let imageLink = "http://graph.facebook.com/\(userFBID)/picture?type=small"
        //    let url = NSURL(string: imageLink)
         //   let data2 = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            //            comImage.image = UIImage(data: data!)
            
           // cell.userImage.image = UIImage(data:data2!)
        
            
            
            //GET TEH USER IMAGE
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
                            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? custom_cell {
                                cellToUpdate.userImage?.image = upimage
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
                        cellToUpdate.userImage?.image = upimage
                    }
                })
            }

            
            
            
            
            
            
            
        let authorTap = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
        // 4
        authorTap.delegate = self
        cell.author_label?.tag = indexPath.row
        cell.author_label?.userInteractionEnabled = true
        cell.author_label?.addGestureRecognizer(authorTap)
        
            
            
            let authorTap2 = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
            // 4
            authorTap2.delegate = self
            cell.userImage?.tag = indexPath.row
            cell.userImage?.userInteractionEnabled = true
            cell.userImage?.addGestureRecognizer(authorTap2)
         
            
            
            let likersTap = UITapGestureRecognizer(target: self, action:Selector("showLikers:"))
            likersTap.delegate = self
            //            cell.likerButtonLabel?.tag = indexPath.row
            //            cell.likerButtonLabel?.userInteractionEnabled = true
            //            cell.likerButtonLabel?.addGestureRecognizer(likersTap)
            cell.heart_label?.tag = indexPath.row
            cell.heart_label?.userInteractionEnabled = true
            cell.heart_label?.addGestureRecognizer(likersTap)
            
            
            
            
            let repliesTap = UITapGestureRecognizer(target: self, action:Selector("showReplies:"))
            repliesTap.delegate = self
            cell.replyButtonImage?.tag = indexPath.row
            cell.replyButtonImage?.userInteractionEnabled = true
            cell.replyButtonImage?.addGestureRecognizer(repliesTap)
            
            let repliesTap2 = UITapGestureRecognizer(target: self, action:Selector("showReplies:"))
            repliesTap2.delegate = self
            cell.replyButtonLabel?.tag = indexPath.row
            cell.replyButtonLabel?.userInteractionEnabled = true
            cell.replyButtonLabel?.addGestureRecognizer(repliesTap2)
            
            let repliesTap3 = UITapGestureRecognizer(target: self, action:Selector("showReplies:"))
            repliesTap3.delegate = self
            cell.replyNumLabel?.tag = indexPath.row
            cell.replyNumLabel?.userInteractionEnabled = true
            cell.replyNumLabel?.addGestureRecognizer(repliesTap3)
            
            
            
            
            
//            
            
//
//            
            let shareTap = UITapGestureRecognizer(target: self, action:Selector("shareComment:"))
            shareTap.delegate = self
            cell.shareLabel?.tag = indexPath.row
            cell.shareLabel?.userInteractionEnabled = true
            cell.shareLabel?.addGestureRecognizer(shareTap)
           // cell.bringSubviewToFront(cell.shareLabel)
           // cell.contentView.bringSubviewToFront(cell.shareLabel)
            
            let shareTap2 = UITapGestureRecognizer(target: self, action:Selector("shareComment:"))
            shareTap2.delegate = self
            cell.shareButton?.tag = indexPath.row
            cell.shareButton?.userInteractionEnabled = true
            cell.shareButton?.addGestureRecognizer(shareTap2)
           // cell.bringSubviewToFront(cell.shareButton)
//
            
        //find out if the user has liked the comment or not
        var hasLiked = voterCache[indexPath.row] as String!
        
        if(hasLiked == "yes"){
            cell.heart_icon?.userInteractionEnabled = true
            cell.heart_icon?.image = UIImage(named: "heart_full.png")
            
            let voteDown = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
            // 4
            voteDown.delegate = self
            cell.heart_icon?.tag = indexPath.row
            cell.heart_icon?.addGestureRecognizer(voteDown)
            
            
        }
        else if(hasLiked == "no"){
            cell.heart_icon?.userInteractionEnabled = true
            cell.heart_icon?.image = UIImage(named: "heart_empty.png")
            
            let voteUp = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
            // 4
            voteUp.delegate = self
            cell.heart_icon?.tag = indexPath.row
            cell.heart_icon?.addGestureRecognizer(voteUp)
        }
            
            
            let voteUp2 = UITapGestureRecognizer(target: self, action:Selector("toggleCommentVote:"))
            cell.likerButtonHolder?.userInteractionEnabled = true
            voteUp2.delegate = self
            cell.likerButtonHolder?.tag = indexPath.row
            cell.likerButtonHolder?.addGestureRecognizer(voteUp2)
            
            
            let focusImage = UITapGestureRecognizer(target: self, action:Selector("showImageFullscreen:"))
            focusImage.delegate = self
            cell.comImage.userInteractionEnabled = true
            cell.comImage?.tag = indexPath.row
            cell.comImage?.addGestureRecognizer(focusImage)
            
            //give a loading gif to UI
            var urlgif = NSBundle.mainBundle().URLForResource("loader2", withExtension: "gif")
            var imageDatagif = NSData(contentsOfURL: urlgif!)
            
            
            let imagegif = UIImage.animatedImageWithData(imageDatagif!)
            
            cell.comImage.image = imagegif
            
            
            
            //GET TEH COMMENT IMAGE
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
            //there are no comments, send an instructions page
        else{
            
            
            var cell = tableView.dequeueReusableCellWithIdentifier("custom_cell_no_images") as! custom_cell_no_images
            
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            cell.separatorInset.left = -10
            cell.layoutMargins = UIEdgeInsetsZero
            cell.tag = 400
            
            
            
            //set the cell contents with the ajax data
            cell.comment_label?.text = "Be the first to make a post! Click me to invite your friends. Or don't. I don't care, I'm not even real! 👻"
            cell.comment_id = "none"
            cell.author_label?.text = "Seymor Butts"
            cell.loc_label?.text = "Your Building"
            cell.heart_label?.text = "1"
            cell.time_label?.text = "1 S"
            cell.replyNumLabel?.text = "0"
         
            
            let userFBID = "100008847672713"
            cell.user_id = userFBID
            
            // cell.userImage.frame = CGRectMake(20, 20, 20, 20)
            let testUserImg = "http://graph.facebook.com/\(userFBID)/picture?type=small"
            var imgURL: NSURL = NSURL(string: testUserImg)!
            
            let data = NSData(contentsOfURL: imgURL) //make sure your image in this url does exist, otherwise unwrap in a if let check
            
            if(data != nil){
                cell.userImage?.image = UIImage(data: data!)
            }
        
            
            
            
            
    
                cell.heart_icon?.image = UIImage(named: "heart_full.png")

            
            
            
            return cell
            
            
            
            
        }
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        

        
        
        
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let repView = mainStoryboard.instantiateViewControllerWithIdentifier("comment_reply_id") as CommentReplyViewController
//        let indCell = tableView.cellForRowAtIndexPath(indexPath)
//        if(indCell?.tag == 100){
//            let gotCell = tableView.cellForRowAtIndexPath(indexPath) as custom_cell_no_images
//            
//            repView.sentLocation = currentUserLocation
//            repView.commentID = gotCell.comment_id
//            //profView.comment = gotCell.comment_label.text!
//            // profView.userFBID = gotCell.user_id
//            
//            //profView.userName = gotCell.author_label.text!
//        }
//        if(indCell?.tag == 200){
//            let gotCell = tableView.cellForRowAtIndexPath(indexPath) as custom_cell
//            
//            repView.sentLocation = currentUserLocation
//            repView.commentID = gotCell.comment_id
//            //profView.comment = gotCell.comment_label.text!
//            //profView.userFBID = gotCell.user_id
//            
//            //profView.userName = gotCell.author_label.text!
//        }
//        
//        
//        self.presentViewController(repView, animated: true, completion: nil)
        
        
        
        //
        
        //
        
        
        let indCell = tableView.cellForRowAtIndexPath(indexPath)
        
        if(indCell?.tag == 100){
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let comView = mainStoryboard.instantiateViewControllerWithIdentifier("com_focus_scene_id") as! ThirdViewController
            
            let gotCell = tableView.cellForRowAtIndexPath(indexPath) as! custom_cell_no_images
            
            comView.sentLocation = currentUserLocation
            comView.commentID = gotCell.comment_id
          //  comView.imgLink = "none2"
           // comView.comment = gotCell.comment_label.text!
           // comView.author = gotCell.author_label.text!
           // comView.authorFBID = gotCell.user_id
           // comView.locString = gotCell.loc_label.text!
           // comView.timeString = gotCell.time_label.text!
            //profView.comment = gotCell.comment_label.text!
             //comView.userFBID = gotCell.user_id
            
            //profView.userName = gotCell.author_label.text!
            
            self.presentViewController(comView, animated: true, completion: nil)
        }
        if(indCell?.tag == 200){
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let comView = mainStoryboard.instantiateViewControllerWithIdentifier("com_focus_scene_id") as! ThirdViewController
            
            let gotCell = tableView.cellForRowAtIndexPath(indexPath) as! custom_cell
            
            comView.sentLocation = currentUserLocation
            comView.commentID = gotCell.comment_id
           // comView.imgLink = gotCell.imageLink
          //  comView.comment = gotCell.comment_label.text!
          //  comView.author = gotCell.author_label.text!
          //  comView.authorFBID = gotCell.user_id
          //  comView.locString = gotCell.loc_label.text!
          //  comView.timeString = gotCell.time_label.text!
            //profView.comment = gotCell.comment_label.text!
            //profView.userFBID = gotCell.user_id
           // comView.userFBID = gotCell.user_id
            
            //profView.userName = gotCell.author_label.text!
            
            self.presentViewController(comView, animated: true, completion: nil)
        }
        if(indCell?.tag == 300){
            
            
            
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let comView = mainStoryboard.instantiateViewControllerWithIdentifier("LocationPeakViewControllerID") as! LocationPeakViewController
            
            let gotCell = tableView.cellForRowAtIndexPath(indexPath) as! custom_cell_location

            comView.savedFBID = savedFBID
            comView.locationName = gotCell.locationLabel.text!
            comView.latLon = gotCell.latLon
            comView.userLatLon = currentUserLocation
            self.presentViewController(comView, animated: true, completion: nil)
        }
        if(indCell?.tag == 400){
            // 1
            
            if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                // 2
                var controller = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                // 3
                controller.setInitialText("Check out Hive!")
                // 4
                self.presentViewController(controller, animated:true, completion:nil)
            }
            else {
                // 3
                println("no Facebook account found on device")
            }
        }
        
        
        

        
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
        let maxVal = 0 - self.navBar.frame.height
        
        
        if(byNum > 0){
            byNum*2.5
        }
        
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
    
    func loadFakePlaces(){
        
        //let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_throw_fake_places")
        
        
        
        //at myriad gardens
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_video_feed_1")
        
        
        
        //at cuppies and joe
        //let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_video_feed_3")
        
        
        
        //at the skatepark before refresh
        //let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_video_feed_4")
        
        
        //at the Sherlocks before refreshre
        //let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_video_feed_6")
        
        //at the Sherlocks after refresh (Jayce)
        //let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_video_feed_7")
        
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["fbid":savedFBID, "recentLocation":currentUserLocation] as Dictionary<String, String>
        
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
                
//                dispatch_async(dispatch_get_main_queue(),{
//                    
//                    
//                    if(self.currentUserLocation == "none"){
//                        self.showErrorMessage("We're having trouble getting your location.", targetString: "loadNewComments")
//                    }
//                    else{
//                        self.showErrorMessage("We're having trouble getting new comments.", targetString: "loadNewComments")
//                    }
//                    
//                })
                
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
    
    
    
    
    
    
    
    func loadFakePlaces2(){
        
        //let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_throw_fake_places")
        
        
        
        //refresh at skatepark
       // let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_video_feed_5")
        
        
        //refresh at Sherlocks
        //let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_video_feed_7")
        
        //refresh at cuppies
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_video_feed_8")
        
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["fbid":savedFBID, "recentLocation":currentUserLocation] as Dictionary<String, String>
        
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
                
                //                dispatch_async(dispatch_get_main_queue(),{
                //
                //
                //                    if(self.currentUserLocation == "none"){
                //                        self.showErrorMessage("We're having trouble getting your location.", targetString: "loadNewComments")
                //                    }
                //                    else{
                //                        self.showErrorMessage("We're having trouble getting new comments.", targetString: "loadNewComments")
                //                    }
                //
                //                })
                
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
    
    
    
    func loadAllInfo(){
        
        
        showLoadingScreen()
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_the_feed")
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        var params = ["fbid":savedFBID, "recentLocation":currentUserLocation] as Dictionary<String, String>
        
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
                
                dispatch_async(dispatch_get_main_queue(),{
                    
                    
                    if(self.currentUserLocation == "none"){
                        self.showErrorMessage("We're having trouble getting your location.", targetString: "loadNewComments")
                    }
                    else{
                        self.showErrorMessage("We're having trouble getting new comments.", targetString: "loadNewComments")
                    }
                    
                })
                
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
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_the_feed")
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
                
                dispatch_async(dispatch_get_main_queue(),{

                
                if(self.currentUserLocation == "none"){
                    self.showErrorMessage("We're having trouble getting your location.", targetString: "loadNewComments")
                }
                else{
                    self.showErrorMessage("We're having trouble getting new comments.", targetString: "loadNewComments")
                }
                    
            })
                
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
    
    
    func showUser1ProfileFromLocation(sender: UIGestureRecognizer){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let profView = mainStoryboard.instantiateViewControllerWithIdentifier("profile_scene_id") as! ProfileViewController
        
        var authorLabel:AnyObject
        
        authorLabel = sender.view!
        
        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        
        
        self.presentViewController(profView, animated: true, completion: nil)
    }
    
    
    func showUserProfile(sender: UIGestureRecognizer){
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let profView = mainStoryboard.instantiateViewControllerWithIdentifier("profile_scene_id") as! ProfileViewController
        
        
        //var authorLabel = sender.view? as UILabel
        var authorLabel:AnyObject
        
        authorLabel = sender.view!
        
        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell_no_images
            
            //profView.comment = gotCell.comment_label.text!
            profView.userFBID = gotCell.user_id
            
            profView.userName = gotCell.author_label.text!
        }
        if(indCell?.tag == 200){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell
            
            //profView.comment = gotCell.comment_label.text!
            profView.userFBID = gotCell.user_id
            
            profView.userName = gotCell.author_label.text!
        }
        if(indCell?.tag == 300){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell_location
            
            if(authorLabel as! NSObject == gotCell.user1Pic){
                profView.userName = theJSON["results"]![authorLabel.tag]["user1Name"] as! String!
                profView.userFBID = theJSON["results"]![authorLabel.tag]["user1fb"] as! String!
            }
            if(authorLabel as! NSObject == gotCell.user2Pic){
                profView.userName = theJSON["results"]![authorLabel.tag]["user2Name"] as! String!
                profView.userFBID = theJSON["results"]![authorLabel.tag]["user2fb"] as! String!
            }
            if(authorLabel as! NSObject == gotCell.user3Pic){
                profView.userName = theJSON["results"]![authorLabel.tag]["user3Name"] as! String!
                profView.userFBID = theJSON["results"]![authorLabel.tag]["user3fb"] as! String!
            }
            
            if(authorLabel as! NSObject == gotCell.user1NameLabel){
                profView.userName = theJSON["results"]![authorLabel.tag]["user1Name"] as! String!
                profView.userFBID = theJSON["results"]![authorLabel.tag]["user1fb"] as! String!
            }
            if(authorLabel as! NSObject == gotCell.user2NameLabel){
                profView.userName = theJSON["results"]![authorLabel.tag]["user2Name"] as! String!
                profView.userFBID = theJSON["results"]![authorLabel.tag]["user2fb"] as! String!
            }
            if(authorLabel as! NSObject == gotCell.user3NameLabel){
                profView.userName = theJSON["results"]![authorLabel.tag]["user3Name"] as! String!
                profView.userFBID = theJSON["results"]![authorLabel.tag]["user3fb"] as! String!
            }
            
        }
        
        
        self.presentViewController(profView, animated: true, completion: nil)
        
        
    }
    
    
    func showImageFullscreen(sender: UIGestureRecognizer){
        println("Presenting Likers, ya heard.")
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let imView = mainStoryboard.instantiateViewControllerWithIdentifier("Image_focus_controller") as! ImageFocusController
        
        var daLink = "none"
        
        var authorLabel:AnyObject
        
        authorLabel = sender.view!
        
        
        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell_no_images
            
        }
        if(indCell?.tag == 200){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell
            
            daLink = gotCell.imageLink
        }
        
        imView.imageLink = daLink
        
        self.presentViewController(imView, animated: true, completion: nil)
        
    }

    
    func showLikers(sender: UIGestureRecognizer){
        
        println("Presenting Likers, ya heard.")
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let likeView = mainStoryboard.instantiateViewControllerWithIdentifier("comment_likers_id") as! CommentLikersViewController
        
        var authorLabel:AnyObject
        
        authorLabel = sender.view!
        
        
        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell_no_images
            
            likeView.sentLocation = currentUserLocation
            likeView.commentID = gotCell.comment_id
            
            //profView.comment = gotCell.comment_label.text!
            // profView.userFBID = gotCell.user_id
            
            //profView.userName = gotCell.author_label.text!
        }
        if(indCell?.tag == 200){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell
            
            likeView.sentLocation = currentUserLocation
            likeView.commentID = gotCell.comment_id
            //profView.comment = gotCell.comment_label.text!
            //profView.userFBID = gotCell.user_id
            
            //profView.userName = gotCell.author_label.text!
        }
        
        
        self.presentViewController(likeView, animated: true, completion: nil)
        
    }
    
    func showReplies(sender: UIGestureRecognizer){
        
        println("SLKFJS:LDKFJ")
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let repView = mainStoryboard.instantiateViewControllerWithIdentifier("comment_reply_id") as! CommentReplyViewController
        
        var authorLabel:AnyObject

        authorLabel = sender.view!
        
        
        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell_no_images
            
            repView.sentLocation = currentUserLocation
            repView.commentID = gotCell.comment_id
            //profView.comment = gotCell.comment_label.text!
           // profView.userFBID = gotCell.user_id
            
            //profView.userName = gotCell.author_label.text!
        }
        if(indCell?.tag == 200){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: authorLabel.tag, inSection: 0)) as! custom_cell
            
            repView.sentLocation = currentUserLocation
            repView.commentID = gotCell.comment_id
            //profView.comment = gotCell.comment_label.text!
            //profView.userFBID = gotCell.user_id
            
            //profView.userName = gotCell.author_label.text!
        }
        
        
        self.presentViewController(repView, animated: true, completion: nil)
        
    }
    

    
    func clickComLink(sender: UIGestureRecognizer){
        var sharedButton:AnyObject
        
        sharedButton = sender.view!
        
        
        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag!, inSection: 0)) as! custom_cell_no_images

            let link = gotCell.urlLink

            UIApplication.sharedApplication().openURL(NSURL(string:link)!)
        }
        if(indCell?.tag == 200){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag!, inSection: 0)) as! custom_cell
            
            let link = gotCell.urlLink
            
            UIApplication.sharedApplication().openURL(NSURL(string:link)!)

        }
        
        
        
        
        

        
    }
    
    
    func shareComment(sender: UIGestureRecognizer){

        
        println("DID PRESS SHARE")
        var sharedButton:AnyObject
//        if(sender.view? == UIImageView()){
//            
//          sharedButton = sender.view? as UIImageView
//            
//        }
//        else{
//            sharedButton = sender.view? as UILabel
//        }
        
       sharedButton = sender.view!
    

        
        let indCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag, inSection: 0))
        
        if(indCell?.tag == 100){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag!, inSection: 0)) as! custom_cell_no_images
            
            
            let shareCom = gotCell.comment_label.text as String!
            let shareAuth = gotCell.author_label.text as String!
            
            let giveMess = "'\(shareCom)'  @\(shareAuth) \n\n @SoLoCoHive (http://apple.co/1yTV9Fj)"

            
            
            
            let objectsToShare = [giveMess]
            
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop,
                UIActivityTypeAddToReadingList,
                UIActivityTypePostToTencentWeibo,
                UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypeMail,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToWeibo,UIActivityTypePrint]
            //
            
            self.presentViewController(activityVC, animated: true, completion: nil)
            
            
            
        }
        if(indCell?.tag == 200){
            let gotCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: sharedButton.tag!, inSection: 0)) as! custom_cell

            
            let shareCom = gotCell.comment_label.text as String!
            let shareAuth = gotCell.author_label.text as String!
            
            let giveMess = "'\(shareCom)'  @\(shareAuth) \n\n @SoLoCoHive (http://apple.co/1yTV9Fj)"
            let hiveSite = NSURL(string: "http://apple.co/1yTV9Fj")
            
            let shareImage = gotCell.comImage?.image as UIImage!
            
                let objectsToShare = [giveMess, shareImage]
            
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
             activityVC.popoverPresentationController?.sourceView = self.view
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop,
                                                    UIActivityTypeAddToReadingList,
                                                    UIActivityTypePostToTencentWeibo,
                                                    UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact,UIActivityTypeMail,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,UIActivityTypePostToWeibo,UIActivityTypePrint]
            //
            
            self.presentViewController(activityVC, animated: true, completion: nil)
            
            
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
    
    
    
    
    
    // pragma mark - layout

    func showInstructionsScreen(){
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let color: UIColor = UIColor( red: CGFloat(217.0/255.0), green: CGFloat(217.0/255.0), blue: CGFloat(217.0/255.0), alpha: CGFloat(0.6) )
        
        let w = screenSize.width * 1.0
        let h = screenSize.height * 1.0
        
        let xPos = screenSize.width/2 - w/2
        let yPos = screenSize.height/2 - h/2
        
        let holdView = UIView(frame: CGRect(x: xPos, y: yPos, width: w, height: h))
        holdView.backgroundColor = color
        holdView.tag = 2000
        
        
        
        
        //holdView.layer.borderWidth=1.0
        holdView.layer.masksToBounds = false
       // holdView.layer.borderColor = color
        //profilePic.layer.cornerRadius = 13
      //  holdView.layer.cornerRadius = holdView.frame.size.height/10
        holdView.clipsToBounds = true
        
        view.addSubview(holdView)
        
        let w2 = w * 0.8
        let h2 = w2*(4/3)
        
        
        let ins1 = UIImageView(frame: CGRect(x: w/2 - w2/2, y: h/2 - h2/2, width: w2, height: h2))
        
        ins1.backgroundColor = UIColor.yellowColor()
        let removeSelf1 = UITapGestureRecognizer(target: self, action:Selector("removeInsSlide:"))
        ins1.userInteractionEnabled = true
        removeSelf1.delegate = self
        //ins1.tag = indexPath.row
        ins1.addGestureRecognizer(removeSelf1)
        
        
        
        
        
        let ins2 = UIImageView(frame: CGRect(x: w/2 - w2/2, y: h/2 - h2/2, width: w2, height: h2))
        
        ins2.backgroundColor = UIColor.orangeColor()
        let removeSelf2 = UITapGestureRecognizer(target: self, action:Selector("removeInsSlide:"))
        ins2.userInteractionEnabled = true
        removeSelf2.delegate = self
        //ins1.tag = indexPath.row
        ins2.addGestureRecognizer(removeSelf2)
        
        
        
        let ins3 = UIImageView(frame: CGRect(x: w/2 - w2/2, y: h/2 - h2/2, width: w2, height: h2))
        
        ins3.backgroundColor = UIColor.redColor()
        let removeSelf3 = UITapGestureRecognizer(target: self, action:Selector("removeInsSlide:"))
        ins3.userInteractionEnabled = true
        removeSelf3.delegate = self
        ins3.tag = 101
        ins3.addGestureRecognizer(removeSelf3)
        
        
        holdView.addSubview(ins3)
        holdView.addSubview(ins2)
        holdView.addSubview(ins1)
    }
    
    func removeInsSlide(sender: UIGestureRecognizer){
        var authorLabel:AnyObject
        
        authorLabel = sender.view!
        
        if(authorLabel.tag == 101){
            //authorLabel.superviewremoveFromSuperview()
            authorLabel.superview??.removeFromSuperview()
        }
        else{
            authorLabel.removeFromSuperview()
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
    
    func showErrorMessage(errorString: NSString, targetString: NSString){
        
        removeLoadingScreen()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let squareSize = screenSize.width * 0.5
        let xPos = screenSize.width/2 - squareSize/2
        let yPos = screenSize.height/2 - squareSize/2
        
        let holdView = UIView(frame: CGRect(x: xPos, y: yPos, width: squareSize, height: squareSize*1.1))
        holdView.backgroundColor = UIColor.whiteColor()
        holdView.tag = 998
        
        holdView.layer.borderWidth=1.0
        holdView.layer.masksToBounds = false
        holdView.layer.borderColor = UIColor.blackColor().CGColor
        //profilePic.layer.cornerRadius = 13
        holdView.layer.cornerRadius = holdView.frame.size.height/10
        holdView.clipsToBounds = true
        
        view.addSubview(holdView)
        
        
        
        
        
        
        var label = UILabel(frame: CGRectMake(holdView.frame.width*0.1, -0.2*holdView.frame.height, holdView.frame.width*0.8, holdView.frame.height*0.8))
        label.textAlignment = NSTextAlignment.Center
        label.text = errorString as? String
        label.numberOfLines = 0
        holdView.addSubview(label)
        
        
        let button   = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        button.frame = CGRectMake(0, holdView.frame.height*0.6, holdView.frame.width, holdView.frame.height*0.2)
        //button.backgroundColor = UIColor.greenColor()
        button.setTitle("RETRY", forState: UIControlState.Normal)
        let s = NSSelectorFromString(targetString as! String)
        let s2 = NSSelectorFromString("removeErrorScreen")
        button.addTarget(self, action:s, forControlEvents: UIControlEvents.TouchUpInside)
        button.addTarget(self, action:s2, forControlEvents: UIControlEvents.TouchUpInside)
        holdView.addSubview(button)
   
    }
    

    func removeErrorScreen(){
       
        for view in self.view.subviews {
            if(view.tag == 998){
                view.removeFromSuperview()
            }
        }
        
    }
    
    @IBAction func showWriteViewController(){
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        //let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("test_view_switcher") as UIViewController
        let writeView = mainStoryboard.instantiateViewControllerWithIdentifier("write_comment_scene_id") as! WriteCommentViewController
        
        writeView.sentLocation = currentUserLocation
        
        
        // self.dismissViewControllerAnimated(true, completion: nil)
        
        self.presentViewController(writeView, animated: true, completion: nil)
        
    }
    
    

    
    
    
    
    
    //pragma mark - core location
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            
            if (error != nil) {
                println("Error:" + error.localizedDescription)
                return
                
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
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
    


    func didPullRefresh(sender:AnyObject)
    {
            //loadNewComments()
        
        //loadFakePlaces2()
        
        if(customSC.selectedSegmentIndex == 0){
            loadClusters()
        }
        else if(customSC.selectedSegmentIndex == 1){
            
           loadComments()
        }
    
        

        self.refreshControl.endRefreshing()
    }
    
    
    func parseHTMLString(daString:NSString) -> [NSString]{
        
        
        println("DA STRING:\(daString)")
        let detector = NSDataDetector(types: NSTextCheckingType.Link.rawValue, error: nil)
        
        let fakejf = String(daString)
        //let length = fakejf.utf16Count
        let length = count(fakejf.utf16)
        let daString2 = daString as! String
       // let links = detector?.matchesInString(daString, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, length)).map {$0 as NSTextCheckingResult}
        
        let links = detector?.matchesInString(daString2, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, length)).map {$0 as! NSTextCheckingResult}
        
//        var d = daString as StringE
//        if (d.containsString("Http://") == true){
//            println(daString)
//            println("YEAH BUDDY")
//        }
        
        var retString = NSString(string: "none")
//        

        return links!.filter { link in
            return link.URL != nil
            }.map { link -> NSString in
                //let urString = String(contentsOfURL: link.URL!)
                let urString = link.URL!.absoluteString
                println("DA STRING:\(urString)")
                retString = urString!
                return urString!
        }
        
       // var newString = retString
//        
        return [retString]
        //return "OH YEAH"
    }
    
    
    
    
    
    
    
    
    
    
    
    
    //Give the device token to server to set up APNS (push notifications)
    
    func throwDeviceToken(){
        let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_update_user_token")
        
        
        //START AJAX
        var request = NSMutableURLRequest(URL: url!)
        var session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        let dToke = defaults.stringForKey("userDeviceToken")
        var sToke = "none"
        
        if(dToke != nil){
            sToke = dToke!
        }
        
        println("DEVICE TOKEN:\(sToke)")
       
        var params = ["fbid":savedFBID, "token":sToke] as Dictionary<String, String>
        
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
                    

                    
                }
                else {
                    // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                    
                }
            }
        })
        task.resume()
        //END AJAX
        

    }

}