//
//  ProfileViewController.swift
//  layout_1
//
//  Created by Rijul Gupta on 3/7/15.
//  Copyright (c) 2015 Rijul Gupta. All rights reserved.
//


import UIKit


//http://graph.facebook.com/xUID/picture?width=720&height=720
class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{
    
    
    
    var commingFrom = "nil"
    
    var userName = "none"
    var userFBID = "none"
  
        
        @IBOutlet var profilePic: UIImageView!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    var isBounce:Bool! = false
    var oldScrollPost:CGFloat = 0.0
        //@IBOutlet var loadingScreen: UIImageView!
        
        @IBOutlet var tableView:UITableView!
        @IBOutlet var navBar:UINavigationBar!
        @IBOutlet var navTitle:UINavigationItem!
        @IBOutlet var postLabelHolder: UIView!
    @IBOutlet var numPostLabel:UILabel!
    
        
        @IBOutlet var locLable:UILabel!
        @IBOutlet var timeLabel:UILabel!
        @IBOutlet var followersName:UILabel!
        @IBOutlet var followersLabel:UILabel!
        @IBOutlet var followingName:UILabel!
        @IBOutlet var followingLabel:UILabel!
    
    @IBOutlet var followButton:UIButton!
        
        var imageCache = [String : UIImage]()
        var userImageCache = [String: UIImage]()
    
    var voterCache = [Int : String]()
    var voterValueCache = [Int : String]()
        //let transportItems = ["Bus","Helicopter","Truck","Boat","Bicycle","Motorcycle","Plane","Train","Car","Scooter","Caravan"]
        
        let leftHandItems: [String] = ["","Last Check In", "Posts", "Followers", "Following"]
        
        var rightHandItems: [String] = ["","@This Place", "250", "92", "99"]
        
        var theJSON: NSDictionary!
        var theUserJSON: NSDictionary!
        var hasLoaded = false
        var numOfCells = 0
    
    var currentUserLocation = "none"
        
        override func viewDidLoad() {
            super.viewDidLoad()
            //titleItem.title = "TESTING"
            
            
             var myCustomViewController: ViewController = ViewController(nibName: nil, bundle: nil)
            
            currentUserLocation = myCustomViewController.currentUserLocation
            
            var url = NSBundle.mainBundle().URLForResource("loader2", withExtension: "gif")
            var imageData = NSData(contentsOfURL: url!)
            
            // Returns an animated UIImage
            
            //self.navBar.topItem.title = "SDKFJ"
            
            navTitle.title = "My Profile"
            //var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("reload_table"), userInfo: nil, repeats: false)
            
            
            
            // tableView.tableFooterView = UIView(frame: CGRectZero)
            
            //  self.tableView.rowHeight = tableView.frame.height/5

            
            let color: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(217.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0) )
            
            postLabelHolder.layer.borderWidth=2.0
            postLabelHolder.layer.masksToBounds = false
            postLabelHolder.layer.borderColor = color.CGColor//UIColor.blackColor().CGColor
            
            //profilePic.layer.cornerRadius = 13
            postLabelHolder.clipsToBounds = true
            
            
            let followingTap = UITapGestureRecognizer(target: self, action:Selector("showFollowing"))
            // 4
            followingTap.delegate = self
            followingLabel.userInteractionEnabled = true
            followingLabel.addGestureRecognizer(followingTap)
            followingName.userInteractionEnabled = true
            followingName.addGestureRecognizer(followingTap)
            
            
            
            let followersTap = UITapGestureRecognizer(target: self, action:Selector("showFollowers"))
            // 4
            followersTap.delegate = self
            followersLabel.userInteractionEnabled = true
            followersLabel.addGestureRecognizer(followersTap)
            followersName.userInteractionEnabled = true
            followersName.addGestureRecognizer(followersTap)
            
            
            
            tableView.estimatedRowHeight = 300.0
            tableView.rowHeight = UITableViewAutomaticDimension
            
        }
        
        
        override func viewDidAppear(animated: Bool) {
            super.viewDidAppear(animated)
            
            getUserPicture()
            loadUserComments()
            showLoadingScreen()
            self.getUserInfo()
            // removeLoadingScreen()
        }
    
    override func viewDidLayoutSubviews() {
        
        let color: UIColor = UIColor( red: CGFloat(255.0/255.0), green: CGFloat(217.0/255.0), blue: CGFloat(0.0/255.0), alpha: CGFloat(1.0) )
        self.tableView.separatorColor = color
        //self.tableView.separatorStyle
        self.tableView.separatorInset.left = 0
        self.tableView.layoutMargins = UIEdgeInsetsZero
    }
    
        func getUserPicture(){
            
            //let defaults = NSUserDefaults.standardUserDefaults()
            //let fbid = defaults.stringForKey("saved_fb_id") as String!
            
            let url = NSURL(string: "http://graph.facebook.com/\(userFBID)/picture?width=200&height=200")
            let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
            profilePic.image = UIImage(data: data!)
            
            
            //
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
            let karmaView = mainStoryboard.instantiateViewControllerWithIdentifier("karma_scene_id") as! KarmaViewController
            
            
            self.presentViewController(karmaView, animated: true, completion: nil)
            
        }
    
        //pragma mark - table view
        
        func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return numOfCells
            //make sure the json has loaded before we do anything
            //return 5
        }
        
        
        func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
        {
            let testImage = theJSON["results"]![indexPath.row]["image"] as! String!
            
            if(testImage == "none"){
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
                }
                
                
                let userFBID2 = theJSON["results"]![indexPath.row]["user_id"] as! String!
                cell.user_id = userFBID2
                
                // cell.userImage.frame = CGRectMake(20, 20, 20, 20)
                let testUserImg = "http://graph.facebook.com/\(userFBID2)/picture?type=small"
                //     let imageLink = "http://graph.facebook.com/\(userFBID)/picture?type=small"
          
                
                var upimage = self.userImageCache[testUserImg]
                if( upimage == nil ) {
                    //If the image does not exist, we need to download it
                    
                    var imgURL: NSURL = NSURL(string: testUserImg)!
                    
                    //Download an NSData representation of the image at the URL
                    let request: NSURLRequest = NSURLRequest(URL: imgURL)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                        if error == nil {
                            upimage = UIImage(data: data)
                            
                            //  Store the image in to our cache
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
                
                
                
//                let authorTap = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
//                // 4
//                authorTap.delegate = self
//                cell.author_label?.tag = indexPath.row
//                cell.author_label?.userInteractionEnabled = true
//                cell.author_label?.addGestureRecognizer(authorTap)
                
                
                
                
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
                }
                
                
                let userFBID2 = theJSON["results"]![indexPath.row]["user_id"] as! String!
                cell.user_id = userFBID2
                let testUserImg = "http://graph.facebook.com/\(userFBID2)/picture?type=small"
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
                
                
                
                
                
                
                
                
//                let authorTap = UITapGestureRecognizer(target: self, action:Selector("showUserProfile:"))
//                // 4
//                authorTap.delegate = self
//                cell.author_label?.tag = indexPath.row
//                cell.author_label?.userInteractionEnabled = true
//                cell.author_label?.addGestureRecognizer(authorTap)
//                
//                
//                
                
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
        
        
        
        func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
            
            
            //
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let comView = mainStoryboard.instantiateViewControllerWithIdentifier("com_focus_scene_id") as! ThirdViewController
            //
            
            
            let indCell = tableView.cellForRowAtIndexPath(indexPath)
            
            if(indCell?.tag == 100){
                let gotCell = tableView.cellForRowAtIndexPath(indexPath) as! custom_cell_no_images
                
                comView.sentLocation = currentUserLocation
                comView.commentID = gotCell.comment_id
            }
            if(indCell?.tag == 200){
                let gotCell = tableView.cellForRowAtIndexPath(indexPath) as! custom_cell
                
                comView.sentLocation = currentUserLocation
                comView.commentID = gotCell.comment_id
            }
            
            
            
            self.presentViewController(comView, animated: true, completion: nil)
            
            
        }
        
        
        
        //User info buttons
        
        func showFollowers(){
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let friendView = mainStoryboard.instantiateViewControllerWithIdentifier("user_friends_scene_id") as! UserFriendsViewController
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let fbid = defaults.stringForKey("saved_fb_id") as String!
            
            
            friendView.ajaxRequestString = "followers"
            friendView.userFBID = userFBID
            // self.dismissViewControllerAnimated(true, completion: nil)
            
            self.presentViewController(friendView, animated: true, completion: nil)
        }
        
        func showFollowing(){
            
            println("SLDKFJLS:DKFJLS:DKFSDF")
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let friendView = mainStoryboard.instantiateViewControllerWithIdentifier("user_friends_scene_id") as! UserFriendsViewController
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let fbid = defaults.stringForKey("saved_fb_id") as String!
            
            
            friendView.ajaxRequestString = "following"
            friendView.userFBID = userFBID
            // self.dismissViewControllerAnimated(true, completion: nil)
            
            self.presentViewController(friendView, animated: true, completion: nil)
            
        }
        //AJAX
        
        func getUserInfo(){
            
            
            let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_user_info")
            //START AJAX
            var request = NSMutableURLRequest(URL: url!)
            var session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            let defaults = NSUserDefaults.standardUserDefaults()
            var fbid = defaults.stringForKey("saved_fb_id") as String!
            
            
            var params = ["fb_id":userFBID, "gfb_id":fbid] as Dictionary<String, String>
            
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
                    
                    self.removeLoadingScreen()
                    
                }
                else {
                    // The JSONObjectWithData constructor didn't return an error. But, we should still
                    
                    
                    
                    // check and make sure that json has a value using optional binding.
                    if let parseJSON = json {
                        
                        
                        //                    self.rightHandItems[1] = ""
                        // let leftHandItems: [String] = ["","Last Check In", "Posts", "Followers", "Following"]
                        self.rightHandItems[1] = parseJSON["results"]![0]["lastLoc"] as! String! ?? ""
                        self.rightHandItems[2] = parseJSON["results"]![0]["comments"] as! String! ?? ""
                        self.rightHandItems[3] = parseJSON["results"]![0]["followers"] as! String! ?? ""
                        self.rightHandItems[4] = parseJSON["results"]![0]["following"] as! String! ?? ""
                        
                        
                        
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            //self.locLable!.text = parseJSON["results"]![0]["lastLoc"] as! String! ?? ""
                            self.locLable!.text = "Sherlock's Pub"
                            //self.timeLabel!.text = parseJSON["results"]![0]["lastTime"] as! String! ?? ""
                            self.timeLabel!.text = "5 mins ago"
                            self.followersLabel!.text = parseJSON["results"]![0]["followers"] as! String! ?? ""
                            self.followingLabel!.text = parseJSON["results"]![0]["following"] as! String! ?? ""
                            self.numPostLabel!.text = parseJSON["results"]![0]["comments"] as! String! ?? ""
                            
                            let folCheck = parseJSON["results"]![0]["isFollowing"] as! String! ?? ""
                            if(folCheck == "no"){//user is not following
                                self.followButton.setImage(UIImage(named: "Follow.png"), forState: UIControlState.Normal)
                            }
                            else{
                                self.followButton.setImage(UIImage(named: "Unfollow.png"), forState: UIControlState.Normal)
                            }
                            self.removeLoadingScreen()
                            // self.tableView.reloadData()
                        })
                        //
                        
                        
                        //   self.reload_table()
                        
                    }
                    else {
                        // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                        //   self.showErrorScreen("top")
                    }
                }
            })
            task.resume()
            //END AJAX
            
            
            
        }
        
        
        
        
        
        // Facebook Delegate Methods
//        
//        func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
//            
//        }
//        
//        func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser){
//            
//            // getMyFriends()
//        }
//        
//        func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
//           // did_press_logout()
//            println("User Logged Out")
//        }
//        
//        func loginView(loginView : FBLoginView!, handleError:NSError) {
//            println("Error: \(handleError.localizedDescription)")
//        }
//        
    
        func parseHTMLString(daString:NSString) -> [NSString]{
            
            let daString2 = daString as! String
            
            println("DA STRING:\(daString)")
            let detector = NSDataDetector(types: NSTextCheckingType.Link.rawValue, error: nil)
            
            let fakejf = String(daString)
            //let length = fakejf.utf16Count
            let length = count(fakejf.utf16)
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
        
        
        
    @IBAction func did_press_back(){
        
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
        func loadUserComments(){
            
            
            // showLoadingScreen()
            let url = NSURL(string: "http://groopie.pythonanywhere.com/mobile_get_user_comments")
            //START AJAX
            var request = NSMutableURLRequest(URL: url!)
            var session = NSURLSession.sharedSession()
            request.HTTPMethod = "POST"
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let fbid = defaults.stringForKey("saved_fb_id") as String!
            
            // var params = ["fbid":savedFBID, "recentLocation":currentUserLocation, "radiusValue":String(radValue)] as Dictionary<String, String>
            
            var params = ["fbid":userFBID, "gfbid":fbid] as Dictionary<String, String>
            
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
        
    
    func writeVoterCache(){
        
        let finNum = (theJSON["results"]!.count - 1)
        
        if(finNum >= 0){
            
            for index in 0...finNum{
                self.voterCache[index] = theJSON["results"]![index]["has_liked"] as? String
                self.voterValueCache[index] = theJSON["results"]![index]["hearts"] as? String
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
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let savedFBID = defaults.stringForKey("saved_fb_id") as String!
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
            
            
            let defaults = NSUserDefaults.standardUserDefaults()
            let savedFBID = defaults.stringForKey("saved_fb_id") as String!
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
        
        let initVal:CGFloat = 10
        //let maxVal = 0 - self.profilePic.frame.height - self.followButton.frame.height
        let maxVal = 0 - self.profilePic.frame.height - self.postLabelHolder.frame.height - 20
        
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
    
    func removeLoadingScreen(){
        //self.loadingScreen.alpha = 0.0
        
        for view in self.view.subviews {
            if(view.tag == 999){
                view.removeFromSuperview()
            }
        }
    }
    
    
    @IBAction func toggle_user_follow(){
        
        
       // self.followButton.titleLabel?.text = "..."
        
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
                    
                    let valTest = parseJSON["results"]![0]["value"] as! String!
                    
                    if(valTest == "yes"){//user did just follow
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            
                            //self.followButton.titleLabel?.text = "done"
                            //self.followButton.setTitle("unfollow", forState: UIControlState.Normal)
                            self.followButton.setImage(UIImage(named: "Unfollow.png"), forState: UIControlState.Normal)
                        })
                    }
                    else{
                        //user did just unfollow
                        dispatch_async(dispatch_get_main_queue(),{
                            
                            
                            //self.followButton.titleLabel?.text = "done"
                            //self.followButton.setTitle("follow", forState: UIControlState.Normal)
                            self.followButton.setImage(UIImage(named: "Follow.png"), forState: UIControlState.Normal)
                        })
                        
                    }
                    
                }
                else {
                    
                    
                }
            }
        })
        task.resume()
        //END AJAX
        
    }

 
    
    
}